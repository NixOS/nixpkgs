{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "archimedes-2.0.0";

  src = fetchurl {
    url = "mirror://gnu/archimedes/${name}.tar.gz";
    sha256 = "1ajg4xvk5slv05fsbikrina9g4bmhx8gykk249yz21pir67sdk4x";
  };

  meta = {
    description = "GNU package for semiconductor device simulations";
    homepage = http://www.gnu.org/software/archimedes;
    license = "GPLv2+";
    platforms = with stdenv.lib.platforms; linux;
  };
}
