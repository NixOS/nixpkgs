{ stdenv, fetchurl, cairo, expat, fftwSinglePrec, fluidsynth, glib
, gtk, jack2, ladspaH , libglade, lv2, pkgconfig }:

stdenv.mkDerivation rec {
  name = "calf-${version}";
  version = "0.0.19";

  src = fetchurl {
    url = "mirror://sourceforge/calf/${name}.tar.gz";
    sha256 = "1v1cjbxv5wg6rsa2nfz1f8r7cykcpx6jm5ccqmzx866dggiff1hi";
  };

  buildInputs = [ 
    cairo expat fftwSinglePrec fluidsynth glib gtk jack2 ladspaH
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
