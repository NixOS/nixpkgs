{ stdenv, fetchurl, lib, expat, octave, libxml2, texinfo, zip }:
stdenv.mkDerivation rec {
  pname = "gama";
  version = "2.17";

  src = fetchurl {
    url = "mirror://gnu/${pname}/${pname}-${version}.tar.gz";
    sha256 = "sha256-AyUjcYDUjAYI4p0vVDO7SGqhbO83Kesd+JUUgQf5GPU=";
  };

  buildInputs = [ expat ];

  nativeBuildInputs = [ texinfo zip ];

  checkInputs = [ octave libxml2 ];
  doCheck = true;

  meta = with lib ; {
    description = "Tools for adjustment of geodetic networks";
    homepage = "https://www.gnu.org/software/gama/";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
  };
}
