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
  version = "3.15.1";

  src = fetchFromGitHub {
    owner = "vnotex";
    repo = "vnote";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-A0OJzhvHP+muPI8N23zD4RTiyK0m3JGr/3uJ0Tqz97c=";
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
    changelog = "https://github.com/vnotex/vnote/releases/tag/v${finalAttrs.src.rev}";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.linux;
  };
})
