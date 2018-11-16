{ stdenv, fetchFromGitHub, qmake, pkgconfig, boost, gdal, proj
, qtbase, qtsvg, qtwebkit }:

stdenv.mkDerivation rec {
  name = "merkaartor-${version}";
  version = "0.18.3";

  src = fetchFromGitHub {
    owner = "openstreetmap";
    repo = "merkaartor";
    rev = version;
    sha256 = "0ls3q8m1hxiwyrypy6qca8wczhl4969ncl0sszfdwfv70rzxjk88";
  };

  nativeBuildInputs = [ qmake pkgconfig ];

  buildInputs = [ boost gdal proj qtbase qtsvg qtwebkit ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "OpenStreetMap editor";
    homepage = http://merkaartor.be/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ];
  };
}
