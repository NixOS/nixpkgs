{
  cmake,
  fetchFromGitHub,
  lib,
  pkg-config,
  qt6,
  stdenv,
  udisks,
  xz,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fedora-media-writer-qt";
  version = "5.2.9";

  src = fetchFromGitHub {
    owner = "FedoraQt";
    repo = "MediaWriter";
    rev = finalAttrs.version;
    hash = "sha256-tZ0GzaEzhklD/FJocnRmet+dvBwZoNYVhJfF1NY6puE=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtsvg
    udisks
    xz
  ];

  meta = {
    description = "Write Fedora and other distributions images onto portable devices such as flash disks.";
    homepage = "https://github.com/FedoraQt/MediaWriter";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ atemo-c ];
    platforms = lib.platforms.linux;
    mainProgram = "mediawriter";
  };
})