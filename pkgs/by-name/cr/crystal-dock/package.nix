{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  kdePackages,
  qt6,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "crystal-dock";
  version = "2.2";

  src = fetchFromGitHub {
    owner = "dangvd";
    repo = "crystal-dock";
    rev = "v${finalAttrs.version}";
    hash = "sha256-c5Kae2cZ/DoJ972VT4kQWNUr2cF6Noy3nPIChWok/BA=";
  };

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    kdePackages.layer-shell-qt
    qt6.qtbase
    qt6.qtwayland
  ];

  cmakeDir = "../src";

  meta = with lib; {
    description = "Dock (desktop panel) for Linux desktop";
    mainProgram = "crystal-dock";
    license = licenses.gpl3Only;
    homepage = "https://github.com/dangvd/crystal-dock";
    maintainers = with maintainers; [ rafameou ];
    platforms = platforms.linux;
  };
})
