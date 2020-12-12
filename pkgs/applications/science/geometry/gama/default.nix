{ stdenv, fetchurl, lib, expat, octave, libxml2, texinfo, zip }:
stdenv.mkDerivation rec {
  pname = "gama";
  version = "2.10";

  src = fetchurl {
    url = "mirror://gnu/${pname}/${pname}-${version}.tar.gz";
    sha256 = "14im3ahh849rildvs4qsk009jywf9w84vcmh7w44ajmlwcw7xiys";
  };

  buildInputs = [ expat ];

  nativeBuildInputs = [ texinfo ];

  checkInputs = [ octave libxml2 zip ];
  doCheck = true;

  meta = with lib ; {
    description = "Tools for adjustment of geodetic networks";
    homepage = "https://www.gnu.org/software/gama/";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
  };
}
