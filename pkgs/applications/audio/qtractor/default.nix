{ alsaLib, autoconf, automake, dssi, fetchurl, libjack2
, ladspaH, ladspaPlugins, liblo, libmad, libsamplerate, libsndfile
, libtool, libvorbis, lilv, lv2, pkgconfig, qttools, qtbase, rubberband, serd
, sord, sratom, stdenv, suil }:

stdenv.mkDerivation rec {
  pname = "qtractor";
  version = "0.9.4";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.gz";
    sha256 = "05xrzr48b19mghbpbzjqw5fy6pl9140bm5m929lrsi4rq5hp3xgg";
  };

  nativeBuildInputs = [
    autoconf automake libtool pkgconfig qttools
  ];
  buildInputs =
    [ alsaLib dssi libjack2 ladspaH
      ladspaPlugins liblo libmad libsamplerate libsndfile libtool
      libvorbis lilv lv2 qtbase rubberband serd sord sratom
      suil
    ];

  meta = with stdenv.lib; {
    description = "Audio/MIDI multi-track sequencer";
    homepage = http://qtractor.sourceforge.net;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
