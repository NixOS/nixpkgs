{ stdenv, fetchgit, autoconf, x11, bdftopcf, mkfontdir, ncurses, tcl,
  libXaw }:

stdenv.mkDerivation {
  name = "x3270-3.4ga9";
  src = fetchgit {
    url = git://git.code.sf.net/p/x3270/code;
    rev = "refs/tags/3.4ga9";
    sha256 = "a9e0cf49862d9746e7a273e00a66bbd053cf38c3ed816d6ace19af597576743f";
  };

  patches = [ ./repair-interpreter.patch ];
  
  meta = {
    homepage = http://x3270.bgp.nu/index.html;
    description = "x3270 is an IBM 3270 terminal emulator for the X Window System.";
    platforms = stdenv.lib.platforms.all;
  };

  buildInputs = [ autoconf x11 bdftopcf mkfontdir ncurses tcl libXaw];
  
  preConfigure = "make -f Makefile.aux prepare";
  configureFlags = "--enable-unix"; # TODO only build part of the tools
  preBuild = "make depend";
  installTargets = "install"; # TODO install.man target fails
}

