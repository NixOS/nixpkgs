{
  lib,
  stdenv,
  cmake,
  pkg-config,
  fetchFromGitHub,
  hyprland-qt-support,
  hyprutils,
  kdePackages,
  polkit,
  qt6,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "hyprpolkitagent";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprpolkitagent";
    tag = "v${finalAttrs.version}";
    hash = "sha256-K1nSPFlh5VBWNagcaZ/157gfifAXTH8lzeyfYt/UEX8=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    hyprland-qt-support
    hyprutils
    kdePackages.kirigami-addons
    kdePackages.polkit-qt-1
    polkit
    qt6.qtbase
    qt6.qtsvg
    qt6.qtwayland
  ];

  meta = {
    description = "Polkit authentication agent written in QT/QML";
    homepage = "https://github.com/hyprwm/hyprpolkitagent";
    license = lib.licenses.bsd3;
    maintainers = lib.teams.hyprland.members;
    mainProgram = "hyprpolkitagent";
    platforms = lib.platforms.linux;
  };
})
