{ lib, stdenv, fetchFromGitHub, sqlite, zlib, perl }:

stdenv.mkDerivation rec {
  pname = "tippecanoe";
  version = "1.36.0";

  src = fetchFromGitHub {
    owner = "mapbox";
    repo = pname;
    rev = version;
    sha256 = "0lbmhly4ivnqc6qk1k3sdqvsg6x3nfd8gnjx846bhqj4wag3f88m";
  };

  buildInputs = [ sqlite zlib ];
  checkInputs = [ perl ];

  makeFlags = [ "PREFIX=$(out)" ];

  enableParallelBuilding = true;
  doCheck = true;

  meta = with lib; {
    broken = stdenv.isDarwin || stdenv.isAarch64;
    description = "Build vector tilesets from large collections of GeoJSON features";
    homepage = "https://github.com/mapbox/tippecanoe";
    license = licenses.bsd2;
    maintainers = with maintainers; [ sikmir ];
    platforms = with platforms; linux ++ darwin;
  };
}
