{ stdenv, fetchFromGitHub, makeWrapper, qmake, pkgconfig, boost, gdal, proj
, qtbase, qtsvg, qtwebview, qtwebkit }:

stdenv.mkDerivation rec {
  pname = "merkaartor";
  version = "unstable-2019-11-12";

  src = fetchFromGitHub {
    owner = "openstreetmap";
    repo = "merkaartor";
    rev = "29b3388680a03f1daac0037a2b504ea710da879a";
    sha256 = "0h3d3srzl06p2ajq911j05zr4vkl88qij18plydx45yqmvyvh0xz";
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
    homepage = http://merkaartor.be/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ];
  };
}
