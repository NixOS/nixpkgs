{ alsaLib, autoconf, automake, dssi, fetchurl, gtk2, libjack2
, ladspaH, ladspaPlugins, liblo, libmad, libsamplerate, libsndfile
, libtool, libvorbis, lilv, lv2, pkgconfig, qt4, rubberband, serd
, sord, sratom, stdenv, suil }:

stdenv.mkDerivation rec {
  version = "0.6.7";
  name = "qtractor-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/qtractor/${name}.tar.gz";
    sha256 = "0h5nblfkl4s412c9f02b40nb8c8jq8ypz67z2qn3hkvhx6i9yxsg";
  };

  buildInputs =
    [ alsaLib autoconf automake dssi gtk2 libjack2 ladspaH
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
