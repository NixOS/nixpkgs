{ stdenv, fetchurl, lib, expat, octave, libxml2, texinfo }:
stdenv.mkDerivation rec {
  pname = "gama";
  version = "2.09";

  src = fetchurl {
    url = "mirror://gnu/${pname}/${pname}-${version}.tar.gz";
    sha256 = "0c1b28frl6109arj09v4zr1xs859krn8871mkvis517g5pb55dc9";
  };

  buildInputs = [ expat ];

  nativeBuildInputs = [ texinfo ];

  checkInputs = [ octave libxml2 ];
  doCheck = true;

  meta = with lib ; {
    description = "Tools for adjustment of geodetic networks";
    homepage = "https://www.gnu.org/software/gama/";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
  };
}
