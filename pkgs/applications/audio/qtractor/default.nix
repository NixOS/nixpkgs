{ alsa-lib
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
, mkDerivation
, opusfile
, pkg-config
, qttools
, qtbase
, rubberband
, serd
, sord
, sratom
, lib
, suil
}:

mkDerivation rec {
  pname = "qtractor";
  version = "0.9.23";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.gz";
    sha256 = "sha256-GgDc7WM4nVGlq+8EcwxJ7MnSPYwAej51IMrN0glCTbQ=";
  };

  nativeBuildInputs = [
    cmake
    libtool
    pkg-config
    qttools
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
    qtbase
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
    maintainers = with maintainers; [ goibhniu ];
    platforms = platforms.linux;
  };
}
