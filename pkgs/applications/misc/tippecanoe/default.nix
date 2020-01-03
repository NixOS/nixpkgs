{ stdenv, fetchFromGitHub, sqlite, zlib, perl }:

stdenv.mkDerivation rec {
  pname = "tippecanoe";
  version = "1.34.3";

  src = fetchFromGitHub {
    owner = "mapbox";
    repo = pname;
    rev = version;
    sha256 = "08pkxzwp4w5phrk9b0vszxnx8yymp50v0bcw96pz8qwk48z4xm0i";
  };

  buildInputs = [ sqlite zlib ];
  checkInputs = [ perl ];

  makeFlags = [ "PREFIX=$(out)" ];

  enableParallelBuilding = true;
  doCheck = true;

  meta = with stdenv.lib; {
    description = "Build vector tilesets from large collections of GeoJSON features";
    homepage = https://github.com/mapbox/tippecanoe;
    license = licenses.bsd2;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
