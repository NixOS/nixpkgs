{ stdenv, fetchurl
, pkgconfig
, libpcap
, ncurses
, expat
, pcre
, python3
, libnl
, zlib
, libmicrohttpd
, sqlite
, protobuf
, protobufc
, libusb1
}:

let
  py3 = python3.withPackages(ps: with ps; [ setuptools ]);
in
stdenv.mkDerivation rec {
  pname = "kismet";
  version = "2019-09-R1";

  src = fetchurl {
    url = "https://www.kismetwireless.net/code/${pname}-${version}.tar.xz";
    sha256 = "0vffcvyx777kd65acm9hzcxbf689k33ifkszkwgrbaab0kj3mwy3";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [
    expat
    libmicrohttpd
    libnl
    libpcap
    libusb1
    ncurses
    pcre
    protobuf
    protobufc
    py3
    sqlite
    zlib
  ];

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
