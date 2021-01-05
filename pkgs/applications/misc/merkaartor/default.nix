{ stdenv, fetchFromGitHub, makeWrapper, qmake, pkgconfig, boost, gdal, proj
, qtbase, qtsvg, qtwebview, qtwebkit }:

stdenv.mkDerivation rec {
  pname = "merkaartor";
  version = "unstable-2020-07-07";

  src = fetchFromGitHub {
    owner = "openstreetmap";
    repo = "merkaartor";
    rev = "0db9132ef4d1ee7910d45c3c00302440297c4603";
    sha256 = "sha256-Y2pZby/iN4uFv9zh5x9frOqkrGydi3X6i9peEop0C8k=";
  };

  nativeBuildInputs = [ makeWrapper qmake pkgconfig ];

  buildInputs = [ boost gdal proj qtbase qtsvg qtwebview qtwebkit ];

  enableParallelBuilding = true;

  NIX_CFLAGS_COMPILE = "-DACCEPT_USE_OF_DEPRECATED_PROJ_API_H";

  postInstall = ''
    wrapProgram $out/bin/merkaartor \
      --set QT_QPA_PLATFORM_PLUGIN_PATH ${qtbase.bin}/lib/qt-*/plugins/platforms
  '';

  meta = with stdenv.lib; {
    description = "OpenStreetMap editor";
    homepage = "http://merkaartor.be/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ erictapen ];
  };
}
