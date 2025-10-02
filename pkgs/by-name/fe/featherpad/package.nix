{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
  hunspell,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "featherpad";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "tsujan";
    repo = "FeatherPad";
    tag = "V${finalAttrs.version}";
    hash = "sha256-G47ltOiyNEk/NrFWoXpft/rCJ18t0FTZrc5ReEJL6TU=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.qttools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    hunspell
    qt6.qtbase
    qt6.qtsvg
  ];

  meta = {
    description = "Lightweight Qt5 Plain-Text Editor for Linux";
    homepage = "https://github.com/tsujan/FeatherPad";
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.flosse ];
    license = lib.licenses.gpl3Plus;
  };
})
