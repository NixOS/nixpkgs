{ stdenv, fetchurl, cairo, expat, fftwSinglePrec, fluidsynth, glib
, gtk2, libjack2, ladspaH , libglade, lv2, pkgconfig }:

stdenv.mkDerivation rec {
  name = "calf-${version}";
  version = "0.0.60";

  src = fetchurl {
    url = "http://calf-studio-gear.org/files/${name}.tar.gz";
    sha256 = "019fwg00jv217a5r767z7szh7vdrarybac0pr2sk26xp81kibrx9";
  };

  buildInputs = [ 
    cairo expat fftwSinglePrec fluidsynth glib gtk2 libjack2 ladspaH
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
