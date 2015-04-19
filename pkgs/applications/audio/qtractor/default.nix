{ alsaLib, autoconf, automake, dssi, fetchurl, gtk, jack2
, ladspaH, ladspaPlugins, liblo, libmad, libsamplerate, libsndfile
, libtool, libvorbis, lilv, lv2, pkgconfig, qt4, rubberband, serd
, sord, sratom, stdenv, suil }:

stdenv.mkDerivation rec {
  version = "0.6.6";
  name = "qtractor-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/qtractor/${name}.tar.gz";
    sha256 = "1n70hs4bx4hq3cp2p35jq5vlcans4fk2c35w72244vlqlajx05c0";
  };

  buildInputs =
    [ alsaLib autoconf automake dssi gtk jack2 ladspaH
      ladspaPlugins liblo libmad libsamplerate libsndfile libtool
      libvorbis lilv lv2 pkgconfig qt4 rubberband serd sord sratom
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
