{ lib
, stdenv
, fetchFromGitHub
, qmake
, qtbase
, qtwebengine
, qtx11extras
, wrapQtAppsHook
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vnote";
  version = "3.16.0";

  src = fetchFromGitHub {
    owner = "vnotex";
    repo = "vnote";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-tcu6y2DqdhFE2nbDkiANDk/Mzidcp8PLi8bWZaI6sH0=";
  };

  nativeBuildInputs = [
    qmake
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qtwebengine
    qtx11extras
  ];

  meta = {
    homepage = "https://vnotex.github.io/vnote";
    description = "A pleasant note-taking platform";
    changelog = "https://github.com/vnotex/vnote/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.linux;
  };
})
