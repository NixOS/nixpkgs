{ alsaLib, autoconf, automake, dssi, fetchurl, gtk, jackaudio
, ladspaH, ladspaPlugins, liblo, libmad, libsamplerate, libsndfile
, libtool, libvorbis, pkgconfig, qt4, rubberband, stdenv }:

stdenv.mkDerivation rec {
  version = "0.6.0";
  name = "qtractor-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/qtractor/${name}.tar.gz";
    sha256 = "0aw6g0biqzysnsk5vd6wx3q1khyav6krhjz7bzk0v7d2160bn40r";
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
