{ alsaLib, autoconf, automake, dssi, fetchsvn, gtk, jackaudio,
ladspaH, ladspaPlugins, liblo, libmad, libsndfile, libtool, libvorbis,
pkgconfig, qt4, rubberband, stdenv }:

stdenv.mkDerivation rec {
  version = "svn-1992";
  name = "qtractor-${version}";

  src = fetchsvn {
    url = "http://qtractor.svn.sourceforge.net/svnroot/qtractor/trunk";
    rev = "1992";
    sha256 = "10k0w5pzci21k1i32jzv5gdkbs34iv4hdn6dzp3n5048hvrp1hiy";
  };

  preConfigure = "make -f Makefile.svn";

  buildInputs = [ alsaLib autoconf automake dssi gtk jackaudio ladspaH
    ladspaPlugins liblo libmad libsndfile libtool libvorbis pkgconfig
    qt4 rubberband ];

  meta = with stdenv.lib; {
    description = "Audio/MIDI multi-track sequencer";
    homepage = http://qtractor.sourceforge.net;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
