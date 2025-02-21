{ lib
, alsa-lib
, aubio
, cmake
, dssi
, fetchurl
, flac
, libjack2
, ladspaH
, ladspaPlugins
, liblo
, libmad
, libsamplerate
, libsndfile
, libtool
, libvorbis
, lilv
, lv2
, opusfile
, pkg-config
, qt6
, rubberband
, serd
, stdenv
, sord
, sratom
, suil
}:

stdenv.mkDerivation rec {
  pname = "qtractor";
  version = "1.1.1";

  src = fetchurl {
    url = "mirror://sourceforge/qtractor/qtractor-${version}.tar.gz";
    hash = "sha256-Q/6AS9mZwsG+wF/h0xt77s8qpuLwcO1CjoVaX9ta9Qc=";
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
    changelog = let
      version' = builtins.replaceStrings ["."] ["_"] version;
    in "https://github.com/rncbc/qtractor/blob/qtractor_${version'}/ChangeLog";
    license = licenses.gpl2Plus;
    mainProgram = "qtractor";
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
