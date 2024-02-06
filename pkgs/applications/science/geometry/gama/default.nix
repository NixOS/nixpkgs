{ stdenv, fetchurl, lib, expat, octave, libxml2, texinfo, zip }:
stdenv.mkDerivation rec {
  pname = "gama";
  version = "2.28";

  src = fetchurl {
    url = "mirror://gnu/${pname}/${pname}-${version}.tar.gz";
    sha256 = "sha256-Xcc/4JB7hyM+KHeO32+JlQWUBfH8RXuOL3Z2P0imaxo=";
  };

  buildInputs = [ expat ];

  nativeBuildInputs = [ texinfo zip ];

  env.CXXFLAGS = lib.optionalString stdenv.cc.isClang "-include sstream";

  nativeCheckInputs = [ octave libxml2 ];
  doCheck = true;

  meta = with lib ; {
    description = "Tools for adjustment of geodetic networks";
    homepage = "https://www.gnu.org/software/gama/";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
  };
}
