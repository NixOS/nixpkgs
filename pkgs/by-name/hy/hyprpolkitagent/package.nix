{
  lib,
  stdenv,
  cmake,
  pkg-config,
  fetchFromGitHub,
  hyprutils,
  kdePackages,
  polkit,
  qt6,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "hyprpolkitagent";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprpolkitagent";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-fhG6YqByDW0DAixXXX6AwTJOH3MqDlQ2XrVvpusZ3Ek=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
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
    maintainers = with lib.maintainers; [
      fufexan
      johnrtitor
    ];
    mainProgram = "hyprpolkitagent";
    platforms = lib.platforms.linux;
  };
})
