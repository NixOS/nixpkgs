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
  version = "0.9.39";

  src = fetchurl {
    url = "mirror://sourceforge/qtractor/qtractor-${version}.tar.gz";
    hash = "sha256-5gyPNxthrBbSHvlvJbQ0rvxVEq68uQEg+qnxHQb+NVU=";
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
    license = licenses.gpl2Plus;
    mainProgram = "qtractor";
    maintainers = with maintainers; [ goibhniu ];
    platforms = platforms.linux;
  };
}
