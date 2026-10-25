{
  lib,
  fetchFromGitHub,
  replaceVars,
  udev,
  stdenv,
  pkg-config,
  qt6,
  qt6Packages,
  cmake,
  zlib,
  kmod,
  libxdmcp,
  gnused,
  withPulseaudio ? stdenv.hostPlatform.isLinux,
  libpulseaudio,
  udevCheckHook,
  wayland-protocols,
}:

stdenv.mkDerivation {
  version = "0.6.2-unstable-2025-09-25";
  pname = "ckb-next";

  src = fetchFromGitHub {
    owner = "ckb-next";
    repo = "ckb-next";
    rev = "4bf942dba5e73c2778ef797b6b8dd6b0239aca9a";
    hash = "sha256-sKgA1LZXZ64OixhbBWYUyCN4y29DRG0O0b/bAMd1I8M=";
  };

  buildInputs = [
    udev
    qt6.qtbase
    zlib
    libxdmcp
    qt6.qttools
    qt6Packages.quazip
    qt6.qtwayland
    wayland-protocols
  ]
  ++ lib.optional withPulseaudio libpulseaudio;

  nativeBuildInputs = [
    qt6.wrapQtAppsHook
    pkg-config
    cmake
    udevCheckHook
  ];

  cmakeFlags = [
    "-DINSTALL_DIR_ANIMATIONS=libexec"
    "-DUDEV_RULE_DIRECTORY=lib/udev/rules.d"
    "-DFORCE_INIT_SYSTEM=systemd"
    "-DDISABLE_UPDATER=1"
  ];

  patches = [
    ./install-dirs.patch
    (replaceVars ./modprobe.patch {
      inherit kmod;
    })
  ];

  doInstallCheck = true;

  postInstall = ''
    substituteInPlace "$out/lib/udev/rules.d/99-ckb-next-daemon.rules" \
      --replace-fail "/usr/bin/env sed" "${lib.getExe gnused}"
  '';

  meta = {
    description = "Driver and configuration tool for Corsair keyboards and mice";
    homepage = "https://github.com/ckb-next/ckb-next";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    mainProgram = "ckb-next";
    maintainers = [ ];
  };
}
