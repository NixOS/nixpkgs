{ alsaLib, autoconf, automake, dssi, fetchurl, libjack2
, ladspaH, ladspaPlugins, liblo, libmad, libsamplerate, libsndfile
, libtool, libvorbis, lilv, lv2, pkgconfig, qttools, qtbase, rubberband, serd
, sord, sratom, stdenv, suil }:

stdenv.mkDerivation rec {
  pname = "qtractor";
  version = "0.9.6";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.gz";
    sha256 = "06sa4wl8zr0k8dnjiil0gjwnhrkq95h50xv56ih1y8jgyzxchaxp";
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
