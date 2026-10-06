{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  kdePackages,
  qt6,
  wayland,
  wayland-scanner,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "krema";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "isac322";
    repo = "krema";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FwADI7o4JD/TTm/E5/Gm4b7pThakERY+1rVtaSb+yrM=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    kdePackages.extra-cmake-modules
    qt6.wrapQtAppsHook
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
    changelog = "https://github.com/isac322/krema/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      gpl3Plus
      mit-cmu
    ];
    maintainers = with lib.maintainers; [ isac322 ];
    mainProgram = "krema";
    platforms = lib.platforms.linux;
  };
})
