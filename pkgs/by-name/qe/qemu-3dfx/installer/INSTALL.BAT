@echo off
echo QEMU-3dfx guest wrapper installer
echo.
if "%OS%"=="Windows_NT" goto NT
goto W9X

:W9X
echo Detected Windows 9x/ME. Installing to %WINDIR%...
copy /y 9X\FXMEMMAP.VXD %WINDIR%\SYSTEM
copy /y 9X\GLIDE.DLL %WINDIR%\SYSTEM
copy /y 9X\GLIDE2X.DLL %WINDIR%\SYSTEM
copy /y 9X\GLIDE3X.DLL %WINDIR%\SYSTEM
copy /y 9X\GLIDE2X.OVL %WINDIR%
goto OPENGL_NOTE

:NT
echo Detected Windows NT/2k/XP. Installing to %SystemRoot%...
copy /y NT\FXPTL.SYS %SystemRoot%\system32\drivers\
copy /y NT\GLIDE.DLL %SystemRoot%\system32\
copy /y NT\GLIDE2X.DLL %SystemRoot%\system32\
copy /y NT\GLIDE3X.DLL %SystemRoot%\system32\
echo Registering FXPTL kernel driver (requires Administrator)...
NT\INSTDRV.EXE
goto OPENGL_NOTE

:OPENGL_NOTE
echo.
echo Glide wrappers installed. Reboot recommended.
echo.
echo NOTE: OPENGL32.DLL is NOT installed system-wide. Copy it from
echo the OPENGL32 folder on this disc into each game's install
echo folder if the game uses OpenGL.
echo.
echo DOS users: see DOS\ for GLIDE2X.DXE / GLIDE3X.DXE / GLIDE2X.OVL.
pause
