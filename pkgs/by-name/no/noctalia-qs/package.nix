{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,

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
  libxcb,
  libdrm,
  libgbm ? null,
  vulkan-headers,
  pipewire,
  pam,
  polkit,
  glib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "noctalia-qs";
  version = "0.0.9";

  src = fetchFromGitHub {
    owner = "noctalia-dev";
    repo = "noctalia-qs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oRqz+5AbNKfUWWwN5c83CsSOsUWVGITh0HZg+wX5Q/8=";
  };

  patches = [
    ./0001-fix-unneccessary-reloads.patch
  ];

  nativeBuildInputs = [
    cmake
    ninja
    spirv-tools
    pkg-config
    qt6.qtwayland
    qt6.wrapQtAppsHook
    wayland-scanner
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
    vulkan-headers
    breakpad
    jemalloc
    libxcb
    pam
    pipewire
    polkit
    glib
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

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/noctalia-dev/noctalia-qs";
    description = "Flexbile QtQuick based desktop shell toolkit";
    license = lib.licenses.lgpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "quickshell";
    maintainers = with lib.maintainers; [ iynaix ];
  };
})
