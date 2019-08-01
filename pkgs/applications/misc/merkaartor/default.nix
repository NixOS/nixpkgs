{ stdenv, fetchFromGitHub, makeWrapper, qmake, pkgconfig, boost, gdal, proj
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

  nativeBuildInputs = [ makeWrapper qmake pkgconfig ];

  buildInputs = [ boost gdal proj qtbase qtsvg qtwebkit ];

  enableParallelBuilding = true;

  NIX_CFLAGS_COMPILE = [ "-DACCEPT_USE_OF_DEPRECATED_PROJ_API_H" ];

  postInstall = ''
    wrapProgram $out/bin/merkaartor \
      --set QT_QPA_PLATFORM_PLUGIN_PATH ${qtbase.bin}/lib/qt-*/plugins/platforms
  '';

  meta = with stdenv.lib; {
    description = "OpenStreetMap editor";
    homepage = http://merkaartor.be/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ];
  };
}
