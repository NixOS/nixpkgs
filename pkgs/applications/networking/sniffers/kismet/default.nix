{ lib
, stdenv
, binutils
, elfutils
, fetchurl
, glib
, libcap
, libmicrohttpd
, libnl
, libpcap
, libusb1
, libwebsockets
, lm_sensors
, networkmanager
, pcre
, pkg-config
, openssl
, protobuf
, protobufc
, python3
, sqlite
, withNetworkManager ? false
, withPython ? true
, withSensors ? false
, zlib
}:

stdenv.mkDerivation rec {
  pname = "kismet";
  version = "2022-08-R1";

  src = fetchurl {
    url = "https://www.kismetwireless.net/code/${pname}-${version}.tar.xz";
    hash = "sha256-IUnM6sVSZQhlP00C3PemlOPaPcAAojcqHuS/mYgnl4E=";
  };

  postPatch = ''
    substituteInPlace Makefile.in \
      --replace "-m 4550" ""
  '';

  postConfigure = ''
    sed -e 's/-o $(INSTUSR)//' \
        -e 's/-g $(INSTGRP)//' \
        -e 's/-g $(MANGRP)//' \
        -e 's/-g $(SUIDGROUP)//' \
        -i Makefile
  '';

  nativeBuildInputs = [
    pkg-config
  ] ++ lib.optionals withPython [
    python3
  ];

  buildInputs = [
    binutils
    elfutils
    libcap
    libmicrohttpd
    libnl
    libpcap
    openssl
    libusb1
    libwebsockets
    pcre
    protobuf
    protobufc
    sqlite
    zlib
  ] ++ lib.optionals withNetworkManager [
    networkmanager
    glib
  ] ++ lib.optionals withSensors [
    lm_sensors
  ];

  propagatedBuildInputs = [
  ] ++ lib.optionals withPython [
    (python3.withPackages (ps: [
      ps.numpy
      ps.protobuf
      ps.pyserial
      ps.setuptools
      ps.websockets
    ]))
  ];

  configureFlags = [
  ] ++ lib.optionals (!withNetworkManager) [
    "--disable-libnm"
  ] ++ lib.optionals (!withPython) [
    "--disable-python-tools"
  ] ++ lib.optionals (!withSensors) [
    "--disable-lmsensors"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Wireless network sniffer";
    homepage = "https://www.kismetwireless.net/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
