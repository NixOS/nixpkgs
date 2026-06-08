{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  qt6,
  libx11,
  libxfixes,
  libxtst,
  wayland,
  miniaudio,
  pkg-config,
  kdePackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "CopyQ";
  version = "15.0.0";

  src = fetchFromGitHub {
    owner = "hluk";
    repo = "CopyQ";
    tag = "v${finalAttrs.version}";
    hash = "sha256-D1huGKvYa/GsVeLQcP69MCWF8p+ytcQxlu0qynmYbGw=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    kdePackages.extra-cmake-modules
    qt6.wrapQtAppsHook
    pkg-config
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    qt6.qttools
    qt6.qtdeclarative
    libx11
    libxfixes
    libxtst
    qt6.qtwayland
    wayland
    miniaudio
    kdePackages.kconfig
    kdePackages.kstatusnotifieritem
    kdePackages.knotifications
    kdePackages.kguiaddons
    kdePackages.qca
    kdePackages.qtkeychain
  ];

  cmakeFlags = [
    (lib.cmakeBool "WITH_QT6" true)
    (lib.cmakeFeature "MINIAUDIO_INCLUDE_DIR" "${lib.getInclude miniaudio}/include/miniaudio")
  ];

  meta = {
    homepage = "https://hluk.github.io/CopyQ";
    description = "Clipboard Manager with Advanced Features";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ artturin ];
    # NOTE: CopyQ supports windows and osx, but I cannot test these.
    platforms = lib.platforms.linux;
    mainProgram = "copyq";
  };
})
