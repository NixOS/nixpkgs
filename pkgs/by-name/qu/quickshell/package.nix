{
  lib,
  stdenv,
  fetchFromGitea,

  pkg-config,
  cmake,
  ninja,
  spirv-tools,
  qt6,
  breakpad,
  jemalloc,
  cli11,
  wayland,
  wayland-protocols,
  wayland-scanner,
  xorg,
  libdrm,
  libgbm,
  pipewire,
  pam,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "quickshell";
  version = "0.1.0";

  # github mirror: https://github.com/quickshell-mirror/quickshell
  src = fetchFromGitea {
    domain = "git.outfoxxed.me";
    owner = "quickshell";
    repo = "quickshell";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DdE50ZJN/mKsSF/vc9hrMboOeJ7BST5DD6GNEXgVbWg=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    qt6.qtshadertools
    spirv-tools
    wayland-scanner
    qt6.wrapQtAppsHook
    pkg-config
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtwayland
    qt6.qtsvg
    cli11
    wayland
    wayland-protocols
    libdrm
    libgbm
    breakpad
    jemalloc
    xorg.libxcb
    pam
    pipewire
  ];

  cmakeFlags = [
    (lib.cmakeFeature "DISTRIBUTOR" "Nixpkgs")
    (lib.cmakeBool "DISTRIBUTOR_DEBUGINFO_AVAILABLE" true)
    (lib.cmakeFeature "INSTALL_QML_PREFIX" qt6.qtbase.qtQmlPrefix)
    (lib.cmakeFeature "GIT_REVISION" "tag-v${finalAttrs.version}")
  ];

  cmakeBuildType = "RelWithDebInfo";
  separateDebugInfo = true;
  dontStrip = false;

  meta = {
    homepage = "https://quickshell.outfoxxed.me";
    description = "Flexbile QtQuick based desktop shell toolkit";
    license = lib.licenses.lgpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "quickshell";
    maintainers = with lib.maintainers; [ outfoxxed ];
  };
})
