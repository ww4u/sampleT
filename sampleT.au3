;~ ConsoleWrite("hello")

;~ if ( $CmdLine[0] == 2 ) Then
;~    ConsoleWrite( $CmdLine[1] )
;~    ConsoleWrite( $CmdLine[2] )
;~ EndIf

#include <FileConstants.au3>

#include <Date.au3>
;~ #include <MsgBoxConstants.au3>

;~ MsgBox($MB_SYSTEMMODAL, '', "The Date is:" & _NowDate() & " " & _NowTime() )
;~ Exit


$winName = "一线通模块工具软件"

Local $valStr
Local $outFile
Local $loopCnt
Local $loopDly

Local $controlCnt = 6

; control,name
Local $controls_names[ 64 ] = [ "[CLASS:Edit; INSTANCE:2]", "CH1", _
"[CLASS:Edit; INSTANCE:6]", "CH5", _
"[CLASS:Edit; INSTANCE:10]", "CH9" _
]

;~ Exit
;~ $controls[0] = "[CLASS:Edit; INSTANCE:2]"
;~ $controls[1] = "[CLASS:Edit; INSTANCE:6]"
;~ $controls[2] = "[CLASS:Edit; INSTANCE:10]"

for $i = 0 to $controlCnt - 1
   ConsoleWrite( $controls_names[ $i ] & @CRLF)
Next

;~ ConsoleWrite( "" & "," & "abc" )

;~ Exit

if $CmdLine[0] >= 5 Then
   $outFile = $CmdLine[1]
   $loopCnt = $CmdLine[2]
   $loopDly = $CmdLine[3]

   $controlCnt = $CmdLine[0] - 3
   for $i = 0 to $controlCnt - 1
	  $controls_names[ $i ] = $CmdLine[ 4 + $i ]
   Next
else
   $outFile = "tst.csv"
   $loopCnt = 2
   $loopDly = 1

Endif

$fileHandle = FileOpen( $outFile, $FO_OVERWRITE )

Local $header = "time"
for $i = 1 to $controlCnt - 1 step 2
   $header = $header & "," & $controls_names[ $i ]
next
FileWrite( $fileHandle, $header & @CRLF )

WinActivate( $winName, "" )

; header
;~ $txt = ControlGetText( $winName, "", "[CLASS:Static; INSTANCE:126]" )
;~ FileWrite( $fileHandle, $txt & @CRLF  )

;ControlClick( $winName, "", "[CLASS:Button; INSTANCE:23]" )
for $i = 0 to $loopCnt step 1
   $ts = timeStamp()
   $batch = snapBatch( $winName, $controls_names, $controlCnt )

   $line = $ts & $batch
   ConsoleWrite( $line & @CRLF )
   FileWrite( $fileHandle, $line & @CRLF  )

   Sleep( $loopDly )
Next
FileClose( $fileHandle )

;ConsoleWrite( $valStr )

Func snapControl( $win, $control )
   $txt = ControlGetText( $win, "",  $control )
   Return $txt
EndFunc

Func snapBatch( $win, $controls, $cnt )
   Local $snaps = ""

   for $i = 0 to $cnt - 1 step 2
	  $txt = snapControl( $win, $controls[ $i ] )
	  $snaps = $snaps & "," & $txt
   Next

   Return $snaps
EndFunc

Func timeStamp()
   Return _NowDate() & " " & _NowTime()
EndFunc