{
  lib,
  stdenv,
  fetchurl,
  alsa-lib,
  fluidsynth,
  libjack2,
  cmake,
  pkg-config,
  libsForQt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qsynth";
  version = "1.0.5";

  src = fetchurl {
    url = "mirror://sourceforge/qsynth/qsynth-${finalAttrs.version}.tar.gz";
    hash = "sha256-s1z3gjKZKmsPYFrB6TFHijMUeL9xovSudQ1xphJK3Ng=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    alsa-lib
    fluidsynth
    libjack2
    libsForQt5.qtbase
    libsForQt5.qttools
    libsForQt5.qtx11extras
  ];

  meta = {
    description = "Fluidsynth GUI";
    mainProgram = "qsynth";
    homepage = "https://sourceforge.net/projects/qsynth";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
