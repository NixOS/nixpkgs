{
  lib,
  stdenv,
  fetchFromGitHub,
  qt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "penguin-subtitle-player";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "carsonip";
    repo = "Penguin-Subtitle-Player";
    rev = "v${finalAttrs.version}";
    hash = "sha256-AhdShg/eWqF44W1r+KmcHzbGKF2TNSD/wPKj+x4oQkM=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ qt5.wrapQtAppsHook ];

  buildInputs = [ qt5.qmake ];

  meta = {
    description = "Open-source, cross-platform and standalone subtitle player";
    homepage = "https://github.com/carsonip/Penguin-Subtitle-Player";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ eljamm ];
    platforms = lib.platforms.all;
    mainProgram = "PenguinSubtitlePlayer";
  };
})
