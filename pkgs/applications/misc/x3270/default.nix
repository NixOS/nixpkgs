{ stdenv, fetchurl, autoconf, x11, bdftopcf, mkfontdir, ncurses, tcl,
  libXaw }:

stdenv.mkDerivation {
  name = "x3270-3.4ga9";

  src = fetchurl {
    url = mirror://sourceforge/x3270/suite3270-3.4ga9-src.tgz;
    sha256 = "07iwv4j4d2n7f6iffv2xfi1lyp4vr0m9qw40pidw15h1jczxgps9";
  };

  patches = [ ./repair-interpreter.patch ];
  
  meta = {
    homepage = http://x3270.bgp.nu/index.html;
    description = "An IBM 3270 terminal emulator for the X Window System";
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.all;
  };

  buildInputs = [ autoconf x11 bdftopcf mkfontdir ncurses tcl libXaw];
  
  preConfigure = "make -f Makefile.aux prepare"; # TODO possibly unneeded with tarball
  configureFlags = "--enable-unix"; # TODO only build part of the tools
  preBuild = "make depend";
  installTargets = "install"; # TODO install.man target fails
}

