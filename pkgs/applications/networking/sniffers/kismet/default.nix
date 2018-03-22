{ stdenv, fetchurl, pkgconfig, libpcap, ncurses, expat, pcre, libnl }:

stdenv.mkDerivation rec {
  name = "kismet-${version}";
  version = "2016-07-R1";

  src = fetchurl {
    url = "http://www.kismetwireless.net/code/${name}.tar.xz";
    sha256 = "0dz28y4ay4lskhl0lawqy2dkcrhgfkbg06v22qxzzw8i6caizcmx";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libpcap ncurses expat pcre libnl ];
  postConfigure = ''
    sed -e 's/-o $(INSTUSR)//' \
        -e 's/-g $(INSTGRP)//' \
        -e 's/-g $(MANGRP)//' \
        -e 's/-g $(SUIDGROUP)//' \
        -i Makefile
  '';

  meta = with stdenv.lib; {
    description = "Wireless network sniffer";
    homepage = https://www.kismetwireless.net/;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
