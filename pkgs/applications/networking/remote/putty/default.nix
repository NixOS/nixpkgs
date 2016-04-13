{ stdenv, fetchurl, ncurses, gtk, pkgconfig, autoconf, automake, perl, halibut, libtool }:

stdenv.mkDerivation rec {
  version = "0.67";
  name = "putty-${version}";

  src = fetchurl {
    url = "http://the.earth.li/~sgtatham/putty/latest/${name}.tar.gz";
    sha256 = "0isak6dy5vmfzf9ckcq6jvhgrn3xfmfcmziaa7g2jqm4x1c286c0";
  };

  preConfigure = ''
    perl mkfiles.pl
    ( cd doc ; make );
    sed -e '/AM_PATH_GTK(/d' \
        -e '/AC_OUTPUT/iAM_PROG_CC_C_O' \
        -e '/AC_OUTPUT/iAM_PROG_AR' -i configure.ac
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
