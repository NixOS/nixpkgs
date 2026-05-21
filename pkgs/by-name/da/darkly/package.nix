{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  kdePackages,
  qt6,
  gitUpdater,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "darkly";
  version = "0.5.32";

  src = fetchFromGitHub {
    owner = "Bali10050";
    repo = "Darkly";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bW0untIUe6QMygBPABCMyrnaZCo8E4pKRQGZgLO9aGI=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    qt6.wrapQtAppsHook
    kdePackages.extra-cmake-modules
  ];

  buildInputs = with kdePackages; [
    qtbase
    kconfig
    kcoreaddons
    kcmutils
    kguiaddons
    ki18n
    kiconthemes
    kwindowsystem
    kcolorscheme
    kdecoration
    kirigami
  ];

  cmakeFlags = [
    "-DBUILD_QT5=OFF"
    "-DBUILD_QT6=ON"
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Modern style for Qt applications (fork of Lightly)";
    homepage = "https://github.com/Bali10050/Darkly";
    changelog = "https://github.com/Bali10050/Darkly/releases/tag/v${finalAttrs.version}";
    platforms = lib.platforms.linux;
    license = with lib.licenses; [ gpl2Plus ];
    maintainers = with lib.maintainers; [ pluiedev ];
    mainProgram = "darkly-settings6";
  };
})
