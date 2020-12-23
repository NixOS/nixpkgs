{ alsaLib
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
, stdenv
, suil
}:

mkDerivation rec {
  pname = "qtractor";
  version = "0.9.19";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.gz";
    sha256 = "sha256-98/trRZRvNRPEA4ASS81qp2rMevpo5TIrtsU1TYMuT0=";
  };

  nativeBuildInputs = [
    cmake
    libtool
    pkg-config
    qttools
  ];

  buildInputs = [
    alsaLib
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

  meta = with stdenv.lib; {
    description = "Audio/MIDI multi-track sequencer";
    homepage = "https://qtractor.sourceforge.io";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ goibhniu ];
    platforms = platforms.linux;
  };
}
