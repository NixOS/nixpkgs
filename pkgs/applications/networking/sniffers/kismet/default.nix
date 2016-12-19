{ stdenv, fetchurl, pkgconfig, libpcap, ncurses, expat, pcre, libnl }:

stdenv.mkDerivation rec {
  name = "kismet-${version}";
  version = "2013-03-R1b";

  src = fetchurl {
    url = "http://www.kismetwireless.net/code/${name}.tar.xz";
    sha256 = "0b3wabdkh0p3msphihm4kz5yw02p27ska5lfippfcyn6z1z4svb3";
  };

  buildInputs = [ pkgconfig libpcap ncurses expat pcre libnl ];
  postConfigure = ''
    sed -e 's/-o $(INSTUSR)//' \
        -e 's/-g $(INSTGRP)//' \
        -e 's/-g $(MANGRP)//' \
        -e 's/-g $(SUIDGROUP)//' \
        -i Makefile
  '';

  meta = {
    description = "Wireless network sniffer";
    homepage = http://www.kismetwireless.net/;
    license = "GPL";
    platforms = stdenv.lib.platforms.linux;
  };
}
