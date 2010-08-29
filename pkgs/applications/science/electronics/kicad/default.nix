{stdenv, fetchurl, unzip, cmake, mesa, wxGTK, zlib, libX11}:

stdenv.mkDerivation rec {
  name = "kicad-2010-05-05";

  src = fetchurl {
    url = http://iut-tice.ujf-grenoble.fr/cao/sources/kicad-sources-2010-05-05-BZR2356-stable.zip;
    sha256 = "05w2d7gpafs5xz532agyym5wnf5lw3lawpgncar7clgk1czcha7m";
  };

  buildInputs = [ unzip cmake mesa wxGTK zlib libX11];

  meta = {
    description = "Free Software EDA Suite";
    homepage = http://kicad.sourceforge.net;
    license = "GPLv2";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
