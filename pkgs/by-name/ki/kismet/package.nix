{
  lib,
  stdenv,
  autoreconfHook,
  binutils,
  elfutils,
  fetchurl,
  glib,
  libcap,
  libmicrohttpd,
  libnl,
  libpcap,
  libusb1,
  libwebsockets,
  lm_sensors,
  networkmanager,
  pcre,
  pkg-config,
  openssl,
  protobuf,
  protobufc,
  python3,
  sqlite,
  withNetworkManager ? false,
  withPython ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
  withSensors ? false,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "kismet";
  version = "2023-07-R1";

  src = fetchurl {
    url = "https://www.kismetwireless.net/code/${pname}-${version}.tar.xz";
    hash = "sha256-8IVI4mymX6HlZ7Heu+ocpNDnIGvduWpPY5yQFxhz6Pc=";
  };

  postPatch = ''
    substituteInPlace Makefile.in \
      --replace "-m 4550" ""
    substituteInPlace configure.ac \
      --replace "pkg-config" "$PKG_CONFIG"
  '';

  postConfigure = ''
    sed -e 's/-o $(INSTUSR)//' \
        -e 's/-g $(INSTGRP)//' \
        -e 's/-g $(MANGRP)//' \
        -e 's/-g $(SUIDGROUP)//' \
        -i Makefile
  '';

  strictDeps = true;

  nativeBuildInputs =
    [
      autoreconfHook
      pkg-config
      protobuf
      protobufc
    ]
    ++ lib.optionals withPython [
      (python3.withPackages (ps: [
        ps.numpy
        ps.protobuf
        ps.pyserial
        ps.setuptools
        ps.websockets
      ]))
    ];

  buildInputs =
    [
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
    ]
    ++ lib.optionals withNetworkManager [
      networkmanager
      glib
    ]
    ++ lib.optionals withSensors [
      lm_sensors
    ];

  configureFlags =
    [
      "--disable-wifi-coconut" # Until https://github.com/kismetwireless/kismet/issues/478
    ]
    ++ lib.optionals (!withNetworkManager) [
      "--disable-libnm"
    ]
    ++ lib.optionals (!withPython) [
      "--disable-python-tools"
    ]
    ++ lib.optionals (!withSensors) [
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
