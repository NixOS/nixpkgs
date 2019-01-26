{ stdenv, fetchurl, cmake, qtscript, qtwebengine, gdal, proj, routino, quazip }:

stdenv.mkDerivation rec {
  name = "qmapshack-${version}";
  version = "1.12.1";

  src = fetchurl {
    url = "https://bitbucket.org/maproom/qmapshack/downloads/${name}.tar.gz";
    sha256 = "1d6n7xk0ksxb1fw43s5lb08vgxf6h93k3rb401cbka1inpyf2232";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ qtscript qtwebengine gdal proj routino quazip ];

  cmakeFlags = [
    "-DROUTINO_XML_PATH=${routino}/share/routino"
    "-DQUAZIP_INCLUDE_DIR=${quazip}/include/quazip"
    "-DLIBQUAZIP_LIBRARY=${quazip}/lib/libquazip.so"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://bitbucket.org/maproom/qmapshack/wiki/Home;
    description = "Plan your next outdoor trip";
    license = licenses.gpl3;
    maintainers = with maintainers; [ dotlambda ];
    platforms = with platforms; linux;
  };
}
