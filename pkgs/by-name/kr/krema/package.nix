{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  kdePackages,
  qt6,
  spirv-tools,
  wayland,
  wayland-scanner,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "krema";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "isac322";
    repo = "krema";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lI2XrRxjiSYr1UNgO+tZZSu+wLFPTVapTM8cAvm59V8=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
    kdePackages.extra-cmake-modules
    qt6.wrapQtAppsHook
    spirv-tools
    wayland-scanner
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtshadertools
    qt6.qtwayland
    kdePackages.kcolorscheme
    kdePackages.kconfig
    kdePackages.kcoreaddons
    kdePackages.kcrash
    kdePackages.kdbusaddons
    kdePackages.kglobalaccel
    kdePackages.ki18n
    kdePackages.kiconthemes
    kdePackages.kirigami
    kdePackages.kirigami-addons
    kdePackages.kitemmodels
    kdePackages.kpipewire
    kdePackages.kservice
    kdePackages.kwindowsystem
    kdePackages.kxmlgui
    kdePackages.layer-shell-qt
    kdePackages.plasma-workspace
    wayland
  ];

  meta = {
    description = "Lightweight Wayland-native dock for KDE Plasma 6";
    homepage = "https://krema.bhyoo.com/";
    changelog = "https://github.com/isac322/krema/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = with lib.licenses; [
      gpl3Plus
      mit-cmu
    ];
    maintainers = with lib.maintainers; [ isac322 ];
    mainProgram = "krema";
    platforms = lib.platforms.linux;
  };
})
