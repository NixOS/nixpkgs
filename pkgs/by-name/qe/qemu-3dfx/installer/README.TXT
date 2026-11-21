QEMU-3dfx Guest Wrapper Installer
==================================

To install the Glide wrappers:

  - Mount this CD/ISO inside your guest VM.
  - From a command prompt, navigate to the CD-ROM drive (e.g., D:).
  - Run INSTALL.BAT.

The installer copies the wrappers to the appropriate system directories
based on the detected Windows version (9x/ME or NT/2k/XP), and on NT
also registers the FXPTL kernel driver via INSTDRV.EXE (Administrator
required).

OPENGL32.DLL must be installed PER-GAME, not system-wide. Copy it from
the OPENGL32\ folder on this disc into the install folder of each
OpenGL game you want accelerated. If the game already has its own
OPENGL32.DLL, back it up first (rename to OPENGL32.DLL.BAK).

DOS games (DJGPP / Watcom): the wrappers in DOS\ are not auto-installed.
Copy them next to the game's executable, or to a directory in the game's
LD_LIBRARY_PATH equivalent.

Source: https://github.com/kjliew/qemu-3dfx
