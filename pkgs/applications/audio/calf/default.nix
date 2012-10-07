{ stdenv, fetchurl, cairo, expat, fftwSinglePrec, fluidsynth, glib
, gtk, jackaudio, ladspaH , libglade, lv2, pkgconfig }:

stdenv.mkDerivation rec {
  name = "calf-${version}";
  version = "0.0.19-rc7";

  src = fetchurl {
    url = "mirror://sourceforge/calf/${name}.tar.gz";
    sha256 = "0515pzc7ishrq0j5hza83s0yp3x34r977h776lpky389whcyf45j";
  };

  buildInputs = [ 
    cairo expat fftwSinglePrec fluidsynth glib gtk jackaudio ladspaH
    libglade lv2 pkgconfig
  ];

  meta = with stdenv.lib; {
    homepage = http://calf.sourceforge.net;
    description = "A set of high quality open source audio plugins for musicians";
    license = licenses.lgpl2;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
