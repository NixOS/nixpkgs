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
  version = "2.14";

  src = fetchFromGitHub {
    owner = "dangvd";
    repo = "crystal-dock";
    rev = "v${finalAttrs.version}";
    hash = "sha256-szW3zIgwy0a9NmEax6xemeCdjs3//r7BRfUDeLv+VxE=";
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

  meta = {
    description = "Dock (desktop panel) for Linux desktop";
    mainProgram = "crystal-dock";
    license = lib.licenses.gpl3Only;
    homepage = "https://github.com/dangvd/crystal-dock";
    maintainers = with lib.maintainers; [ rafameou ];
    platforms = lib.platforms.linux;
  };
})
