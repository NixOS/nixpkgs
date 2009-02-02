{stdenv, fetchurl, libpcap, ncurses, expat}:

stdenv.mkDerivation {
  name = "kismet-2008-05-r1";

  src = fetchurl {
    url = http://www.kismetwireless.net/code/kismet-2008-05-R1.tar.gz;
    sha256 = "a298d44f8a6ec977021cd492a720987ded81b5c4baf5f68b36f1282a23c9f7d3";
  };

  buildInputs = [libpcap ncurses expat];
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
