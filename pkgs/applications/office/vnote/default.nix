{ lib
, stdenv
, fetchFromGitHub
, cmake
, qtbase
, qtwebengine
, qtsvg
, qttools
, qt5compat
, qtwayland
, wrapQtAppsHook
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vnote";
  version = "3.18.0";

  src = fetchFromGitHub {
    owner = "vnotex";
    repo = "vnote";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-OpQjMngSEnmtTMLXLllDlIzucdSLSqdFU4ZtPb7ytvQ=";
  };

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qtwebengine
    qtsvg
    qttools
    qt5compat
    qtwayland
  ];

  meta = {
    homepage = "https://vnotex.github.io/vnote";
    description = "Pleasant note-taking platform";
    mainProgram = "vnote";
    changelog = "https://github.com/vnotex/vnote/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.linux;
  };
})
