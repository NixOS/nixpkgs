{
  lib,
  stdenv,
  autoreconfHook,
  binutils,
  elfutils,
  fetchFromGitHub,
  glib,
  libcap,
  libmicrohttpd,
  libnl,
  libpcap,
  libusb1,
  libwebsockets,
  lm_sensors,
  networkmanager,
  nix-update-script,
  nixosTests,
  pcre2,
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

stdenv.mkDerivation (finalPackage: {
  pname = "kismet";
  version = "2023-07-R2";

  src = fetchFromGitHub {
    owner = "kismetwireless";
    repo = "kismet";
    tag = "kismet-${finalPackage.version}";
    hash = "sha256-QwTjjZHnrlATFvHK9PLDTt76UjfZdzCmV6uXVgIMIYg=";
  };

  postPatch = ''
    substituteInPlace Makefile.in \
      --replace-fail "-m 4550" ""
    substituteInPlace configure.ac \
      --replace-fail "pkg-config" "$PKG_CONFIG"
  '';

  postConfigure = ''
    sed -e 's/-o $(INSTUSR)//' \
        -e 's/-g $(INSTGRP)//' \
        -e 's/-g $(MANGRP)//' \
        -e 's/-g $(SUIDGROUP)//' \
        -i Makefile
  '';

  strictDeps = true;

  nativeBuildInputs = [
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
    pcre2
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

  configureFlags = [
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

  passthru = {
    tests.kismet = nixosTests.kismet;
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "^kismet-(\\d+-\\d+-.+)$"
      ];
    };
  };

  meta = {
    description = "Wireless network sniffer";
    homepage = "https://www.kismetwireless.net/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ numinit ];
  };
})
