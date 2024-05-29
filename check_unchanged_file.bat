
@REM -----------------------------------------------------
@REM find unchanged files since some date in svn workspace
@REM -----------------------------------------------------

@echo off

setlocal enabledelayedexpansion

set folder=%1
set ext=%2
set date=%3
set result=result.txt

if "%folder:~-1%" neq "\" (
	set folder=%folder%\
)

cd /d %folder%
del /s /q %result%

for /f %%i in ('dir /b /s /a:-d *.%ext%') do (
	set file=%%i
	set file=!file:%folder%=!

	echo !file!

	for /f "delims=" %%x in ('svn info !file!') do (
		echo %%x | findstr /c:"Last Changed Date: %date%" > nul

		if !errorlevel! equ 0 (
			echo !file! %%x >> %result%
		)
	)
)

pause
