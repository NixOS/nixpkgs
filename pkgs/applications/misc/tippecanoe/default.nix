{ stdenv, fetchFromGitHub, sqlite, zlib, perl }:

stdenv.mkDerivation rec {
  pname = "tippecanoe";
  version = "1.35.0";

  src = fetchFromGitHub {
    owner = "mapbox";
    repo = pname;
    rev = version;
    sha256 = "0v5ycc3gsqnl9pps3m45yrnb1gvw5pk6jdyr0q6516b4ac6x67m5";
  };

  buildInputs = [ sqlite zlib ];
  checkInputs = [ perl ];

  makeFlags = [ "PREFIX=$(out)" ];

  enableParallelBuilding = true;
  doCheck = true;

  meta = with stdenv.lib; {
    description = "Build vector tilesets from large collections of GeoJSON features";
    homepage = "https://github.com/mapbox/tippecanoe";
    license = licenses.bsd2;
    maintainers = with maintainers; [ sikmir ];
    platforms = with platforms; linux ++ darwin;
  };
}
