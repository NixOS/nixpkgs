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
  version = "3.17.0";

  src = fetchFromGitHub {
    owner = "vnotex";
    repo = "vnote";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-NUVu6tKXrrwAoT4BgxX05mmGSC9yx20lwvXzd4y19Zs=";
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
