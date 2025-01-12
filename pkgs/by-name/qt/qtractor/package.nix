{
  lib,
  alsa-lib,
  aubio,
  cmake,
  dssi,
  fetchurl,
  flac,
  libjack2,
  ladspaH,
  ladspaPlugins,
  liblo,
  libmad,
  libsamplerate,
  libsndfile,
  libtool,
  libvorbis,
  lilv,
  lv2,
  opusfile,
  pkg-config,
  qt6,
  rubberband,
  serd,
  stdenv,
  sord,
  sratom,
  suil,
}:

stdenv.mkDerivation rec {
  pname = "qtractor";
  version = "1.5.1";

  src = fetchurl {
    url = "mirror://sourceforge/qtractor/qtractor-${version}.tar.gz";
    hash = "sha256-jBJ8qruWBeukuW7zzi9rRayJL+FC1e3f+O3cb6QfdiE=";
  };

  nativeBuildInputs = [
    cmake
    libtool
    pkg-config
    qt6.qttools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    alsa-lib
    aubio
    dssi
    flac
    libjack2
    ladspaH
    ladspaPlugins
    liblo
    libmad
    libsamplerate
    libsndfile
    libtool
    libvorbis
    lilv
    lv2
    opusfile
    qt6.qtbase
    qt6.qtsvg
    rubberband
    serd
    sord
    sratom
    suil
  ];

  meta = {
    description = "Audio/MIDI multi-track sequencer";
    homepage = "https://qtractor.sourceforge.io";
    changelog = "https://github.com/rncbc/qtractor/blob/v${version}/ChangeLog";
    license = lib.licenses.gpl2Plus;
    mainProgram = "qtractor";
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
