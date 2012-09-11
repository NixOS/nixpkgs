{ stdenv, fetchurl, cairo, expat, glib, gtk, jackaudio, ladspaH
, libglade, lv2, pkgconfig }:

stdenv.mkDerivation rec {
  name = "calf-${version}";
  version = "0.0.18.6";

  src = fetchurl {
    url = "mirror://sourceforge/calf/${name}.tar.gz";
    sha256 = "03w6jjkrr6w8da6qzd0x4dlkg295c6jxby500x4cj07wpbpk6irh";
  };

  buildInputs =
    [ cairo jackaudio gtk glib expat libglade ladspaH lv2 pkgconfig ];

  meta = with stdenv.lib; {
    homepage = http://calf.sourceforge.net;
    description = "A set of high quality open source audio plugins for musicians";
    license = licenses.lgpl2;
    maintainers = [ maintainers.goibhniu ];
  };
}
