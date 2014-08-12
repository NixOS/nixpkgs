{ alsaLib, autoconf, automake, dssi, fetchurl, gtk, jack2
, ladspaH, ladspaPlugins, liblo, libmad, libsamplerate, libsndfile
, libtool, libvorbis, pkgconfig, qt4, rubberband, stdenv }:

stdenv.mkDerivation rec {
  version = "0.6.2";
  name = "qtractor-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/qtractor/${name}.tar.gz";
    sha256 = "08cr4lgm8bkkmsvfljszcqij3i52n989s7ncrbrn17n61rmgf8yw";
  };

  buildInputs =
    [ alsaLib autoconf automake dssi gtk jack2 ladspaH
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
