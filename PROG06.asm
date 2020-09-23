TITLE Program 6     (prog06.asm)

; Author: Madison Woy
; Last Modified:  3/15/2020
; OSU email address: woym@oregonstate.edu
; Course number/section:  CS271-400
; Project Number:   6              Due Date:  3/16/2020
; Description:  This program prompts the user for 10 signed integers and then displays the input as strings, 
;                   it then displays the sum of the inputs as well as their average

INCLUDE Irvine32.inc

; __________________________________________________________________________________________________________________________
; -----------------------------------------------------GETSTRING------------------------------------------------------------
; ** MACRO to display a prompt and save users input to memory **
; receives:			mem location to save user input and mem location to save the length of the users input
; returns:			user input (as ASCII characters) and length of input saved to their respective conditions
; preconditions:		initiated memory locations to save the string and length to
; postconditions:   user input now accessible in memory location passed to macro
; note:   uses ReadString PROC from the Irvine library
; registers changed: ECX, EDX, EAX
; *** THE FOLLWOING CODE WAS ADAPTED FROM AN EXAMPLE PROVIDED DURING LECTURE IN CS 271 AT OREGON STATE UNIVERSITY ***
; __________________________________________________________________________________________________________________________

getString	 MACRO	mem_location, string_length

  ; save registers
		push	ECX
		push	EDX
		
	; prep for readString
		mov		EDX, mem_location
		mov		ECX, 30 
		
	; call readString and save input count (in EAX) to string_length
		call	ReadString
		mov		string_length, EAX
		
	; restore registers
		pop		EDX
		pop		ECX
		
ENDM


; __________________________________________________________________________________________________________________________
; -----------------------------------------------------DISPLAYSTRING--------------------------------------------------------
; ** MACRO to display a string **
; receives:			memory location of string to display
; returns:			prints the string to the screen
; preconditions:		string must be saved in a memory location in order to be passed
; postconditions:   none, string/mem location is unchanged
; note:   uses WriteString PROC from the Irvine library
; registers changed: EDX
; *** THE FOLLWOING CODE WAS ADAPTED FROM AN EXAMPLE PROVIDED DURING LECTURE IN CS 271 AT OREGON STATE UNIVERSITY ***
; __________________________________________________________________________________________________________________________

displayString	MACRO	string
    
  ; save registers
		push	EDX
	
	; prep for PROC
		mov		EDX,string
		
	; print screen
		call	WriteString
		
	; restore registers
		pop		EDX
		
ENDM

; declare the number of inputs the program will ask for and save 
INPUT_SIZE = 10


.data

intro_1			BYTE	"---------------------------------Assignment 6 for CS 271 by Madison Woy---------------------------------", 0
intro_1_1		BYTE	"*** PER EC: VALID INPUT LINES ARE NUMBERED ***", 0
outro_1			BYTE	"If you are reading this then my program worked! Thanks for an awesome quarter!", 0
outro_2			BYTE	"Goodbye!", 0
intro_2			BYTE	"Hello! The program you are using is about to prompt you for 10 signed decimal integers",0
intro_3			BYTE	"When prompted please enter a signed integer small enough to fit in a 32 bit register ",0
intro_4			BYTE	"Once you are done I will display the integers you entered, thier sum and their average value (rounded)",0
prompt_1		BYTE	"Enter a signed integer (please): ",0
error_1			BYTE	"ERROR: Integer too large to fit in 32 bit register or input was not an integer",0
error_2			BYTE	"Try again: ",0
list_txt		BYTE	"Here is a list of the numbers you entered: ",0
list_list		SDWORD	INPUT_SIZE	DUP(?)
sum_txt			BYTE	"The sum of the numbers you entered is: ", 0
sum_sum			DWORD	?
sum_ave			DWORD	?
ave_txt			BYTE	"The rounded average of the numbers you entered is: ", 0
ave_ave			SDWORD	?
temp_int		SDWORD	?
temp			BYTE	30	DUP(?)
temp_size		DWORD	?
num				SDWORD	?
list_count		BYTE	"1: ", 0
				BYTE	"2: ", 0
				BYTE	"3: ", 0
				BYTE	"4: ", 0
				BYTE	"5: ", 0
				BYTE	"6: ", 0
				BYTE	"7: ", 0
				BYTE	"8: ", 0
				BYTE	"9: ", 0
				BYTE	"10: ", 0
error_flag		DWORD	?
space_comma		BYTE	", ", 0

.code
; __________________________________________________________________________________________________________________________
; __________________________________________________________MAIN____________________________________________________________
main PROC

	; introduce the program
		push	OFFSET		intro_1_1
		push	OFFSET		intro_1
		push	OFFSET		intro_2
		push	OFFSET		intro_3
		push	OFFSET		intro_4
		call	introduction

	; get user input using getNums which uses Readval
		push	OFFSET		num				; 44 number to save converted integer as
		push	OFFSET		temp_size		; 40 size of user input
		push	OFFSET		error_flag		; 36 error_flag to signify invalid input
		push	OFFSET		INPUT_SIZE		; 32 number of inputs to be gathered
		push	OFFSET		prompt_1		; 28 prompt for numbers
		push	OFFSET		error_1			; 24 error message
		push	OFFSET		error_2			; 20 error prompt
		push	OFFSET		temp			; 16 location to save temp string (raw user input)
		push	OFFSET		list_list		; 12 list of signed integers gathered
		push	OFFSET		list_count		; 8 input count 
		call	getNums

	; display user input using writeVal
		push	OFFSET		temp			; 28 location to store temp string used during writeval
		push	OFFSET		temp_int		; 24 location to store int ti be converted back to string by writeval
		push	OFFSET		space_comma		; 20 list formatting
		push	OFFSET		list_txt		; 16 title of list
		push	OFFSET		list_list		; 12 list of inputs (converted to integer form)
		push	OFFSET		INPUT_SIZE		; 8 length of list and number of inputs
		call	displayList

	; get the sum 
		push	OFFSET		sum_ave			; 20 extra copy of sum for ave proc
		push	OFFSET		list_list		; 16 list to be summed
		push	OFFSET		sum_sum			; 12 mem location of sum to be stored
		push	OFFSET		INPUT_SIZE		; 8 size of array
		call	getSum

	; display the sum
		push	OFFSET		temp_int		; 20 temporary space to save sum 
		push	OFFSET		sum_txt			; 16 title of number
		push	OFFSET		sum_sum			; 12 value to be displayed
		push	OFFSET		temp			; 8 to be used to display num
		call	displayInfo

	; get the average
		push	OFFSET		ave_ave			; 16 mem location to store ave
		push	OFFSET		sum_ave			; 12 sum of array
		push	OFFSET		INPUT_SIZE		; 8 size of input array
		call	getAverage

	; display the average
		push	OFFSET		temp_int
		push	OFFSET		ave_txt
		push	OFFSET		ave_ave	
		push	OFFSET		temp
		call	displayInfo

	; say goodbye
		push	OFFSET		outro_1
		push	OFFSET		outro_2
		call	farewell

		exit
main ENDP

; _________________________________________________________ENDMAIN__________________________________________________________
; __________________________________________________________________________________________________________________________


; __________________________________________________________________________________________________________________________
; ----------------------------------------------------------INTRO-----------------------------------------------------------
; ** Procedure to introduce programmer and display description of program **
; receives:			addresses of introduction statement as parameters on stack
; returns:			prints the introduction to the screen
; preconditions:		introductory phrases saved into memory locations
; postconditions:   none, memory locations are unchanged
; note:   uses displayString macro
; registers changed: EBP, EDX (pop/pushad used to cleanup stack)
; __________________________________________________________________________________________________________________________

introduction	PROC

  ; set up stack and save registers
		push	EBP
		mov		EBP, ESP
		pushad
		call	CrLf

	; print intro_1
		displayString	 [EBP+20]
		call	CrLf
		call	CrLf
		
	; print intro_1_1
		displayString	 [EBP+24]
		call	CrLf
		call	CrLf
		call	CrLf

	; print intro_2
		displayString	 [EBP+16]
		call	CrLf
		call	CrLf

	; print intro_3
		displayString [EBP+12]
		call	CrLf

	; print intro_4
		displayString [EBP+8]
		call	CrLf
		call	CrLf

  ; clean up stack and return to main
    popad
		pop		EBP
		ret		16
		
introduction	ENDP


; __________________________________________________________________________________________________________________________
; ------------------------------------------------------GETNUMS-------------------------------------------------------------
; ** Procedure to gets user's input, validate it and save it as a signed integer to a list
; receives:			memory location of list, INPUT_SIZE, prompt, error_1, error_2, temp, list_count, error_flag, temp, num
; returns:			an array of signed integers saved to a memory location
; note:				uses the getString Macro and lodsb/stosb
; note:       string conversion and validation done by readVal procedure below, this procedure saves data 
; preconditions:  memory locations set up 
; postconditions:   an array of signed integers saved to memory
; registers changed: all general purpose registers are changed (restored via pushad/popad)
; __________________________________________________________________________________________________________________________

getNums		PROC

	; save registers, set up stackframe and move INPUT_SIZE to ECX
		push	EBP
		mov		EBP, ESP
		mov		EDI, [EBP+12]		; put list in EDI
		mov		ECX, [EBP+32]		; put INPUT_SIZE in ECX
		mov		EAX, 0 
		mov		EDX, [EBP+8]		; put line_count in EDX (line_count is an array of pre formatted numbered strings)

	; save registers
		pushad

start_loop: 
	
	; display list count and spaces
		displayString	EDX
		
	; set up and call readVal which prompts the user and gets/converts/validates string
		push	[EBP+44]	; 24 push num 	
		push	[EBP+40]	; 20 push temp_size to be passed to readval
		push	[EBP+16]	; 16 push temp to be passed to readval
		push	[EBP+28]	; 12 push prompt to be passed to readval
		push	[EBP+36]	; 8 push error_flag to be passed to readval
		call	readVal

error_check:

	; check if error_flag was "set" (1) in readVal if error flag is set, jump to error_loop
		mov		EAX, 1
		mov		EBX, [EBP+36]
		cmp		[EBX], EAX
		je		error_loop

save_num:     ; loop to be entered AFTER a valid number has been recieved from user

	; increment list_count array to call next number label when looped
		add		EDX, 4

	; save num to currently open space in list_list
		mov		EBX, [EBP+44]
		mov		EBX, [EBX]
		mov		[EDI], EBX

	; open next space in list_list and loop to top
		add		EDI, 4
		loop	start_loop

	; add jump to end here so error message is not invoked after loop runs its course
		jmp		end_input

error_loop: 

	; reset error flag
		mov		EAX, [EBP+36] 
		mov		EBX, 0
		mov		[EAX], EBX

	; write error message to the screen
		displayString		[EBP+24]
		call	Crlf

	; display list count and spaces
		displayString	  EDX

	; call readval again with error message (instead of normal prompt) and jump to error_check 
		push	[EBP+44]	; 24 push num 	
		push	[EBP+40]	; 20 push temp_size to be passed to readval
		push	[EBP+16]	; 16 push temp to be passed to readval
		push	[EBP+20]	; 12 push prompt to be passed to readval
		push	[EBP+36]	; 8 push error_flag to be passed to readval
		call	readVal
		jmp		error_check	

end_input:

  ; cleanup stack and return to main
		pop		EBP
		popad
		ret		40
		
getNums		ENDP


; __________________________________________________________________________________________________________________________
; ---------------------------------------------------------READVAL----------------------------------------------------------
; ** Procedure to prompt user ofr and get user's string of digits, validate entry, convert string to signed integer **
; receives:			num, temp_size, temp, error_flag, prompt
; returns:			signed integer saved to num and error_flag set to validate if num is valid
; note:				uses the getString Macro to get string from user
; preconditions:  memory location set up
; postconditions:  signed integer saved to num to be used in getnums and error_flag to be set
; registers changed:  all general purpose registers used and restored via pushad/popad
; __________________________________________________________________________________________________________________________

readVal		PROC

	; save registers and set stack frame
		push	EBP
		mov		EBP, ESP
		pushad
		pushfd

	; display prompt
		displayString	[EBP+12]

	; save users input into temp location via the getString Macro and save length of user input into temp_size
		getString	[EBP+16], [EBP+20]

	; move the length of the string into ECX for loop below
		mov		ECX, [EBP+20]

	; move string into ESI and clear EDX
		mov		ESI, [EBP+16]
		mov		EDX, 0

	; compare first byte to see sign of number
		cmp		BYTE ptr [ESI],'-'
		je		negative_number_flag
		cmp		BYTE ptr [ESI],'+'
		je		positive_number
		jmp		convert_to_num

negative_number_flag: 

	; if number is negative set EDI to 1 and decrement ECX to skip first character via lodsb
		mov		EDI, 1
		dec		ECX
		lodsb
		jmp		convert_to_num

positive_number:

	; if number is positive do nothing except skip first character via lodsb
		lodsb
		dec		ECX

convert_to_num:

	; move byte in AL and point to next byte, ensure direction flag is clear
		clc
		lodsb

	; compare byte to edge cases (ASCII for 0 and ASCII for 9), if the input is outside this range the input is invalid
		cmp		AL, 57
		jg		invalid_input
		cmp		AL, 48
		jl		invalid_input

	; if byte is valid, subtract 48 to get numeric value and multiply that value by 10
		sub		AL, 48		; AL now contains actual integer
		movzx	AX, AL
		movzx	EBX, AX		; sign extend AL
		mov		EAX, 10		
		mul		EDX			; multiply input by 10
		add		EAX, EBX	; add integer of input to num

	; mul sign extends the product of multiplication into EDX:EAX so if EDX is not 0 then overflow has occured and input is invalid
		cmp		EDX, 0	
		jne		invalid_input
		mov		EDX, EAX

	; loop back to top for next byte
		loop	convert_to_num

	; special case of -2147483648
	; if user enters 2147483648 the program will read this as negative because it is too big of a positive number
		cmp		EDX, 2147483648
		je		special_case
		jmp		large_positive_check

special_case:

  ; if the user enters the special case, ensure they meant negative. if so then skip to save number as negation is not necessary
	 	cmp		EDI, 1
		je		save_num

large_positive_check:

	; make sure that large positive integers are not interpretted as negative
	; at this point no number should be negative so any number that is was an invalid input to begin with
		cmp		EDX, 0
		jl		invalid_input

	; check if number needs to be converted to neg
		cmp		EDI, 1
		je		convert_to_neg
		jmp		save_num

convert_to_neg:

  ; negate any number that the user deemed negative
		neg		EDX

save_num:

	; save completed conversion to num
		mov		EAX, [EBP+24]
		mov		[EAX], EDX
		jmp		end_conversion

invalid_input:
	
	; set error_flag to be checked when return 
		mov		EAX, [EBP+8]
		mov		EBX, 1
		mov		[EAX], EBX
		
end_conversion: 

  ; clean up stack and return to main
		popfd
		popad
		pop		EBP
		ret		20

readVal		ENDP


; __________________________________________________________________________________________________________________________
; -------------------------------------------------------DISPLAYLIST--------------------------------------------------------
; ** Procedure to display elements of an array that are saved as singed integers as strings **
; receives:			title of list, list (array of singed integers), size of list, temp, temp_int, space_comma
; returns:			prints the title and the array to screen (both as strings)
; notes: 			uses the displayString macro and the writeVal procedure
; preconditions:		array must be filled with singed integers
; postconditions:   no memory locations changed in this procedure (other than temp locations)
; registers changed:  all general purpose registers used and restored via pushas popad
; *** THE FOLLWOING CODE WAS ADAPTED FROM AN EXAMPLE PROVIDED DURING LECTURE IN CS 271 AT OREGON STATE UNIVERSITY ***
; __________________________________________________________________________________________________________________________

displayList		PROC

  ; set up stack and save registers
		call	CrLf
		push	EBP
		mov		EBP,ESP
		pushad
		mov		ESI,[EBP+12]	; @list
		mov		ECX,[EBP+8]		; ECX is loop control and is the size of the list via push

	; print title of list
		displayString [EBP+16]	
		call	CrLf
		mov		EDX,0

more:

	; get current element and move it into temp_int
		mov		EAX,[ESI]
		mov		EBX, [EBP+24]
		mov		[EBX], EAX

	; push the parameters needed to writeVal
		push	[EBP+28]		; 12 push temp to store string	
		push	[EBP+24]		; 8 push temp_int which has the current element of list 
		call	writeVAl

	; display space and comma
		displayString		[EBP+20]

	; next element in list
		add		ESI,4			;next element   
		loop	more

  ; restore registers and clean up stack 
    popad
		pop EBP
		call CrLf
		ret 24
		
displayList		ENDP


; __________________________________________________________________________________________________________________________
; ---------------------------------------------------------WRITEVAL---------------------------------------------------------
; ** Procedure to convert signed integers back to a str and display str **
; receives:			signed integer to display, temp location to save string to 
; returns:			prints values to the screen
; preconditions:  signed integers saved to memory
; post conditions:  no memoory locations other than temp changed
; note:				uses the displayString Macro
; registers changed: all general purpose registers used and restored via pushad/popad
; __________________________________________________________________________________________________________________________

writeVal		PROC
		
	; set up stack and save registers
		push	EBP
		mov		EBP, ESP			
		cld						; clear the direction flag
		mov		EDI, [EBP+12]	; @temp
		pushad
		mov		ECX, 0		
		mov		EAX, 0

	; check if number is negative and set sign flag
		mov		EAX, [EBP+8]		; move address of temp_int into EAX 
		mov		EAX, [EAX]			; move value of temp_int into EAX
		or		EAX, EAX			; sets SF if negative
		js		negative_num		; jump if number is negative (sign flag set)

	; if number is positive add a '+' to the front of the string (ASCII 43)
		mov		EAX, 43
		stosb
		jmp		division_loop

negative_num:

	; negate number back to input
		neg		EAX
		mov		EBX, [EBP+8]
		mov		[EBX], EAX

	; if number is negative add a '-' to the front of the string (ASCII 45) and NEGATE THE NUMBER BACK
		mov		EAX, 45
		stosb

division_loop:		; loop to get string of number

	; divide temp_int by 10
		mov		EAX, [EBP+8]		; move address of temp_int into EAX 
		mov		EAX, [EAX]			; move value of temp_int into EAX
		cwd							; division prep
		mov		EBX, 10				; get divisor
		xor		EDX, EDX			
		idiv	EBX					; divide

	; move the new value of the element back into temp_int
		mov		EBX, [EBP+8]		
		mov		[EBX], EAX	

	; convert remainder to ASCII and increment digit count in ECX
		add		EDX, 48				; EDX now contains ASCII
		inc		ECX

	; push character to stack to be called in reverse order later
		push	EDX

	; if currrent element is not 0 then loop to top of division loop
		cmp		EAX, 0 
		jg		division_loop

print_string:

	; pop stack into EAX and store byte
		pop		EAX

	; store byte and loop for the amount of digits in the number 
		stosb
		loop	print_string

	; add null 0
		mov		EAX, 0
		stosb

	; print the string
		displayString	[EBP+12]

	; restore everything
		popad
		pop		EBP
		ret	8
		
writeVal	ENDP


; __________________________________________________________________________________________________________________________
; --------------------------------------------------------GETSUM------------------------------------------------------------
; ** Procedure to get the sum of an array of integers**
; receives:			 array to sum, memory location to save sum, mem location to save extra copy of sum and size of array
; returns:			 sum of the array in sum and copy of sum in other mem location
; preconditions:		 array must be filled with integers
; postconditions:   sum saved to memory
; registers changed:  all general purpose registers changed and restores via pushad/popad
; __________________________________________________________________________________________________________________________

getSum		PROC
		
	; set up stack and save registers
		push	EBP
		mov		EBP, ESP
		pushad
		mov		EDI, [EBP+16]	; put list in EDI
		mov		ECX, [EBP+8]	; put input size in ECX
		mov		EDX, 0

sum_nums:
		
	; add value @ EDI to EDX 
		add		EDX, [EDI]

	; move to next element and loop
		add		EDI, 4
		loop	sum_nums

	; save the sum to sum_sum
		mov		EAX, [EBP+12]
		mov		[EAX], EDX

	; save sum to sum_ave
		mov		EAX, [EBP+20]
		mov		[EAX], EDX		

  ; restore registers and return to main
		popad
		pop		EBP
		ret		12
		
getSum		ENDP

; __________________________________________________________________________________________________________________________
; -------------------------------------------------------GETAVERAGE---------------------------------------------------------
; ** Procedure to get the average of an array of integers **
; receives:			 array, memory location to save ave, and sum of array
; returns:			 average of the array in ave
; preconditions:		 array must be filled and sum must have already been found
; registers changed:  EBP, ESP, EAX, EBX, EDX (all restored via pushad/popad)
; __________________________________________________________________________________________________________________________

getAverage		PROC
		
	; set up stack and save registers
		push	EBP
		mov		EBP, ESP
		pushad
		
	; move dividend (sum) into EAX
		mov		EAX, [EBP+12]
		mov		EAX, [EAX]
		cwd

	; move divisor (input_size) into EBX
		mov		EBX, [EBP+8]

	; divide 
		xor		EDX, EDX
		idiv	EBX
	
	; store quotient into ave_ave
		mov		EBX, [EBP+16]
		mov		[EBX], EAX
		
	; restore registers and return to main
	  popad
		pop		EBP
		ret		16
		
getAverage		ENDP

; __________________________________________________________________________________________________________________________
; --------------------------------------------------------DISPLAYINFO-------------------------------------------------------
; ** Procedure that prints out a title and a signed integer to the screen**
; recieves:   mem location of title, temp_int, number to print, temp
; returns:    no memory locations changed other than temps
; notes: 			uses the displayString macro and the writeVal procedure
; preconditions:  title of info saved in memory as a string and singed integer to display saved in memory
; registers changed: EBP all registers saved and restored vai pushad/popad
; __________________________________________________________________________________________________________________________

displayInfo		PROC
		
	; set up stack and save registers
		push	EBP
		mov		EBP, ESP
		pushad

	; display title
		call	Crlf
		displayString	[EBP+16]

	; display the info via writeval
		push	[EBP+8]		; 12 push temp
		push	[EBP+12]	; 8 push temp_int 
		call	writeVal
		call	CrLf
		
	; restore registers and return to main
		popad
		pop EBP
		ret		16

displayInfo		ENDP


; __________________________________________________________________________________________________________________________
; -------------------------------------------------------FAREWELL-----------------------------------------------------------
; ** Procedure to say farewell **
; receives:			addresses of farewell statements as parameters on stack
; returns:			prints the farewell to the screen
; preconditions:		introductory phrases saved into memory locations
; postconditions:   none, memory locations are unchanged
; note:   uses displayString macro
; registers changed: EBP, EDX (pop/pushad used to cleanup stack)
; __________________________________________________________________________________________________________________________
farewell	PROC
		
		push	EBP
		mov		EBP, ESP
		call	CrLf

		; print outro_1
		displayString	[EBP+12]
		call	CrLf

		; print outro_2
		displayString	[EBP+8]
		call	CrLf
		call	CrLf

		pop		EBP
		ret		2

farewell	ENDP

END main