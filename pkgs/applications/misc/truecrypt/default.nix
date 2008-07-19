/*
Requirements for Building TrueCrypt for Linux and Mac OS X:
-----------------------------------------------------------

- GNU Make
- GNU C++ Compiler 4.0 or compatible
- Apple XCode (Mac OS X only)
- pkg-config
- wxWidgets 2.8 library source code (available at http://www.wxwidgets.org)
- FUSE library (available at http://fuse.sourceforge.net and
  http://code.google.com/p/macfuse)


Instructions for Building TrueCrypt for Linux and Mac OS X:
-----------------------------------------------------------

1) Change the current directory to the root of the TrueCrypt source code.

2) Run the following command to configure the wxWidgets library for TrueCrypt
   and to build it:

   $ make WX_ROOT=/usr/src/wxWidgets wxbuild

   The variable WX_ROOT must point to the location of the source code of the
   wxWidgets library. Output files will be placed in the './wxrelease/'
   directory.

3) To build TrueCrypt, run the following command:

   $ make

4) If successful, the TrueCrypt executable should be located in the directory
   'Main'.

By default, a universal executable supporting both graphical and text user
interface is built. To build a console-only executable, which requires no GUI
library, use the 'NOGUI' parameter:

   $ make NOGUI=1 WX_ROOT=/usr/src/wxWidgets wxbuild
   $ make NOGUI=1
*/

{ fetchurl, stdenv, pkgconfig, fuse, gtk, libSM, glibc
}:

stdenv.mkDerivation {
  name = "trueCrypt-6.0a";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://www.sfr-fresh.com/unix/misc/TrueCrypt-6.0a-Source.tar.gz;
    sha256 = "dea0ac2f1f6964d7e88f6751fa9f0a89d0dbfb957e9a557e8dee48492d0b4fac";
  };

  wxWidgets = fetchurl {
    url = mirror://sourceforge/wxwindows/wxX11-2.8.8.tar.gz;
    sha256 = "85e1a458fd9523c68b22af0a51eb507b792894e9ba58a560f9dbe7b6faa6f625";
  };

  buildInputs = [pkgconfig fuse gtk libSM glibc];
  #configureFlags =
  #postInstall = "
}
