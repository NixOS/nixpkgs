{ alsaLib, autoconf, automake, dssi, fetchurl, libjack2
, ladspaH, ladspaPlugins, liblo, libmad, libsamplerate, libsndfile
, libtool, libvorbis, lilv, lv2, pkgconfig, qttools, qtbase, rubberband, serd
, sord, sratom, stdenv, suil, wrapQtAppsHook }:

stdenv.mkDerivation rec {
  pname = "qtractor";
  version = "0.9.11";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.gz";
    sha256 = "02cpjlf3j4sm74hz88r1frnlycs52rs11mzplr2q8plji3ic5w50";
  };

  nativeBuildInputs = [
    autoconf automake libtool pkgconfig qttools wrapQtAppsHook
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
