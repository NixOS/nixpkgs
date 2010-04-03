{stdenv, fetchurl, libpcap, ncurses, expat, pcre}:

stdenv.mkDerivation {
  name = "kismet-2010-01-r1";

  src = fetchurl {
    url = http://www.kismetwireless.net/code/kismet-2010-01-R1.tar.gz;
    sha256 = "106qird64x1v29nz6k5zs9dxxdq6q7fb7d6np0pnwm3dd2p1w7cx";
  };

  buildInputs = [libpcap ncurses expat pcre];
  postConfigure =
    "sed -e 's@-o \$(INSTUSR)@@' \\
        -e 's@-g \$(INSTGRP)@@' \\
        -e 's@-g \$(MANGRP)@@' \\
        -i Makefile";

  meta = {
    description = "Wireless network sniffer";
    homepage = http://www.kismetwireless.net/;
    license = "GPL";
  };
}
