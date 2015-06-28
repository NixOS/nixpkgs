{ stdenv, fetchurl, ncurses, gtk, pkgconfig, autoconf, automake, perl, halibut, libtool }:

stdenv.mkDerivation rec {
  version = "0.64";
  name = "putty-${version}";

  src = fetchurl {
    url = "http://the.earth.li/~sgtatham/putty/latest/${name}.tar.gz";
    sha256 = "089qbzd7w51sc9grm2x3lcbj61jdqsnakb4j4gnf6i2131xcjiia";
  };

  preConfigure = ''
    perl mkfiles.pl
    ( cd doc ; make );
    sed '/AM_PATH_GTK(/d' -i unix/configure.ac
    sed '/AC_OUTPUT/iAM_PROG_CC_C_O' -i unix/configure.ac
    sed '/AC_OUTPUT/iAM_PROG_AR' -i unix/configure.ac
    ./mkauto.sh
    cd unix
  '';

  buildInputs = [ gtk ncurses pkgconfig autoconf automake perl halibut libtool ];

  meta = with stdenv.lib; {
    description = "A Free Telnet/SSH Client";
    longDescription = ''
      PuTTY is a free implementation of Telnet and SSH for Windows and Unix
      platforms, along with an xterm terminal emulator.
      It is written and maintained primarily by Simon Tatham.
    '';
    homepage = http://www.chiark.greenend.org.uk/~sgtatham/putty/;
    license = licenses.mit;
  };
}
