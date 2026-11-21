{
  lib,
  stdenv,
  autoreconfHook,
  binutils,
  elfutils,
  fetchFromGitHub,
  fetchpatch,
  glib,
  libbtbb,
  libcap,
  libmicrohttpd,
  libnl,
  libpcap,
  libusb1,
  libwebsockets,
  lm_sensors,
  mosquitto,
  networkmanager,
  nix-update-script,
  nixosTests,
  pcre2,
  pkg-config,
  openssl,
  protobuf,
  protobufc,
  python3,
  rtl-sdr-librtlsdr,
  sqlite,
  withNetworkManager ? false,
  withPython ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
  withSensors ? false,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kismet";
  version = "2026-10-R1";

  src = fetchFromGitHub {
    owner = "kismetwireless";
    repo = "kismet";
    tag = "kismet-${finalAttrs.version}";
    hash = "sha256-thYxqddJuRUDRLx5lhuDEHOQIqYNuj/OHo/KJETXqnc=";
  };

  patches = [
    # Fix build on arm64, PowerPC, and s390x.
    # https://github.com/kismetwireless/kismet/issues/717
    (fetchpatch {
      name = "fix-arm64-build.patch";
      url = "https://github.com/kismetwireless/kismet/commit/7410efd22776cf0921156739bd454024a603e028.patch";
      hash = "sha256-N9rRk0wOh5LqYm5CkneXR9t8/HPpR8RW4mIMmo35Ui8=";
    })
    (fetchpatch {
      name = "fix-s390x-build.patch";
      url = "https://github.com/kismetwireless/kismet/commit/ee38d431029e0095efa32e89080b0e23bb75e0c0.patch";
      includes = [ "protobuf_decode.h" ];
      hash = "sha256-mDyfpt404j+N5d9r2L4qm7lWd8xPolCugJBLAlE3Hms=";
    })
  ];

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
    libbtbb
    libcap
    libmicrohttpd
    libnl
    libpcap
    openssl
    libusb1
    libwebsockets
    mosquitto
    pcre2
    protobuf
    protobufc
    rtl-sdr-librtlsdr
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
  ]
  ++ lib.optionals stdenv.hostPlatform.isS390x [
    "--disable-usbwifi"
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
