{ alsaLib, autoconf, automake, dssi, fetchurl, gtk, jackaudio
, ladspaH, ladspaPlugins, liblo, libmad, libsamplerate, libsndfile
, libtool, libvorbis, pkgconfig, qt4, rubberband, stdenv }:

stdenv.mkDerivation rec {
  version = "0.5.12";
  name = "qtractor-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/qtractor/${name}.tar.gz";
    sha256 = "0yf2p9l3hj8pd550v3rbbjqkvxnvn8p6nsnm4aj2v5q4mgg2c8cc";
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
