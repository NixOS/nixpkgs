{stdenv, fetchurl, libpcap, ncurses, expat, pcre}:

stdenv.mkDerivation {
  name = "kismet-2011-03-r2";

  src = fetchurl {
    url = http://www.kismetwireless.net/code/kismet-2011-03-R2.tar.gz;
    sha256 = "0r1admlaiq7k0v13d9ci9i9mf5m25i1r5r18bkawsla9fbxrk83i";
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
