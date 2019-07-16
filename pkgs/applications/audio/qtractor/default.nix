{ alsaLib, autoconf, automake, dssi, fetchurl, libjack2
, ladspaH, ladspaPlugins, liblo, libmad, libsamplerate, libsndfile
, libtool, libvorbis, lilv, lv2, pkgconfig, qttools, qtbase, rubberband, serd
, sord, sratom, stdenv, suil }:

stdenv.mkDerivation rec {
  pname = "qtractor";
  version = "0.9.8";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.gz";
    sha256 = "1llajl450yh7bka32ngm4xdva6a2nnxzjc497ydh07rwkap16smx";
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
