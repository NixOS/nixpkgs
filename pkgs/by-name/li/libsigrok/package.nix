{
  lib,
  stdenv,
  fetchgit,
  autoreconfHook,
  pkg-config,
  libzip,
  glib,
  libusb1,
  libftdi1,
  check,
  libserialport,
  doxygen,
  glibmm,
  python3,
  hidapi,
  libieee1284,
  bluez,
  sigrok-firmware-fx2lafw,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "libsigrok";
  version = "0.6.0-unstable-2025-11-20";

  #Use sipeed fork since it seems to be more up to date and supports my device
  src = fetchFromGitHub {
    owner = "sipeed";
    repo = "libsigrok";
    rev = "0ce0720421b6bcc8e65a0c94c5b2883cbfe22d7e";
    hash = "sha256-4aqX+OX4bBsvvb7b1XHKqG6u1Ek3floXDfjr27usZwo=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [
    autoreconfHook
    doxygen
    pkg-config
    python3
  ];
  buildInputs = [
    libzip
    glib
    libusb1
    libftdi1
    check
    libserialport
    glibmm
    hidapi
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libieee1284
    bluez
  ];

  strictDeps = true;

  postInstall = ''
    mkdir -p $out/etc/udev/rules.d
    cp contrib/*.rules $out/etc/udev/rules.d

    mkdir -p "$out/share/sigrok-firmware/"
    cp ${sigrok-firmware-fx2lafw}/share/sigrok-firmware/* "$out/share/sigrok-firmware/"
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    # assert that c++ bindings are included
    # note that this is only true for modern (>0.5) versions; the 0.3 series does not have these
    [[ -f $out/include/libsigrokcxx/libsigrokcxx.hpp ]] \
      || { echo 'C++ bindings were not generated; check configure output'; false; }

    runHook postInstallCheck
  '';

  meta = {
    description = "Core library of the sigrok signal analysis software suite";
    homepage = "https://sigrok.org/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      bjornfor
      vifino
    ];
  };
}
