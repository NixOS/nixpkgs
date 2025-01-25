{
  lib,
  stdenv,
  fetchurl,
  alsa-lib,
  fluidsynth,
  libjack2,
  cmake,
  pkg-config,
  qtbase,
  qttools,
  qtx11extras,
  wrapQtAppsHook,
}:

stdenv.mkDerivation rec {
  pname = "qsynth";
  version = "1.0.2";

  src = fetchurl {
    url = "mirror://sourceforge/qsynth/${pname}-${version}.tar.gz";
    hash = "sha256-SHMPmZMAlC9L5EAecaZNB0pWnq0heeD8bcbhKeI+YOo=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    alsa-lib
    fluidsynth
    libjack2
    qtbase
    qttools
    qtx11extras
  ];

  meta = with lib; {
    description = "Fluidsynth GUI";
    mainProgram = "qsynth";
    homepage = "https://sourceforge.net/projects/qsynth";
    license = licenses.gpl2Plus;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
