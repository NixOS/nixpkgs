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
  version = "1.4.0";

  src = fetchurl {
    url = "mirror://sourceforge/qtractor/qtractor-${version}.tar.gz";
    hash = "sha256-1BuytrG2y/cAa2v4nex2TM0v7SEsUuu1QzBs1DczhkA=";
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

  meta = with lib; {
    description = "Audio/MIDI multi-track sequencer";
    homepage = "https://qtractor.sourceforge.io";
    changelog = "https://github.com/rncbc/qtractor/blob/v${version}/ChangeLog";
    license = licenses.gpl2Plus;
    mainProgram = "qtractor";
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
