{
  stdenv,
  lib,
  fetchFromGitHub,
  alsa-lib,
  pkg-config,
  libsForQt5,
}:

stdenv.mkDerivation {
  pname = "iannix";
  version = "0.9.20-b-unstable-2020-12-09";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "buzzinglight";
    repo = "IanniX";
    rev = "287b51d9b90b3e16ae206c0c4292599619f7b159";
    hash = "sha256-AhoP+Ok78Vk8Aee/RP572hJeM8O7v2ZTvFalOZZqRy8=";
  };

  nativeBuildInputs = [
    pkg-config
    libsForQt5.qmake
    libsForQt5.wrapQtAppsHook
    libsForQt5.qtscript
  ];
  buildInputs = [
    alsa-lib
    libsForQt5.qtbase
    libsForQt5.qtscript
  ];

  qmakeFlags = [ "PREFIX=/" ];

  installFlags = [ "INSTALL_ROOT=$(out)" ];

  meta = {
    description = "Graphical open-source sequencer";
    mainProgram = "iannix";
    homepage = "https://www.iannix.org/";
    license = lib.licenses.lgpl3;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
