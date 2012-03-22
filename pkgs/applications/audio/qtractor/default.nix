{ alsaLib, autoconf, automake, dssi, fetchurl, gtk, jackaudio
, ladspaH, ladspaPlugins, liblo, libmad, libsamplerate, libsndfile
, libtool, libvorbis, pkgconfig, qt4, rubberband, stdenv }:

stdenv.mkDerivation rec {
  version = "0.5.0";
  name = "qtractor-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/qtractor/${name}.tar.gz";
    sha256 = "de5991d2d29b2713d73a90ab29efc24db0be68d8e9ca328062d53d229e902e89";
  };

  buildInputs =
    [ alsaLib autoconf automake dssi gtk jackaudio ladspaH
      ladspaPlugins liblo libmad libsamplerate libsndfile libtool
      libvorbis pkgconfig qt4 rubberband
    ];

  meta = with stdenv.lib; {
    description = "Audio/MIDI multi-track sequencer";
    homepage = http://qtractor.sourceforge.net;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
