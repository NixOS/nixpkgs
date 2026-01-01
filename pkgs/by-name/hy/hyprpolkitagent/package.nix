{
  lib,
<<<<<<< HEAD
  gcc15Stdenv,
=======
  stdenv,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  cmake,
  pkg-config,
  fetchFromGitHub,
  hyprland-qt-support,
  hyprutils,
  kdePackages,
  polkit,
  qt6,
}:
<<<<<<< HEAD
gcc15Stdenv.mkDerivation (finalAttrs: {
=======
stdenv.mkDerivation (finalAttrs: {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "hyprpolkitagent";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprpolkitagent";
    tag = "v${finalAttrs.version}";
    hash = "sha256-39xQ6iitVz9KVJz6PPRR+pkS5hBogq25BDd24eUDOQg=";
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
    teams = [ lib.teams.hyprland ];
    mainProgram = "hyprpolkitagent";
    platforms = lib.platforms.linux;
  };
})
