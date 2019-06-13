{ stdenv, fetchurl, cmake, qtscript, qtwebengine, gdal, proj, routino, quazip }:

stdenv.mkDerivation rec {
  name = "qmapshack-${version}";
  version = "1.12.3";

  src = fetchurl {
    url = "https://bitbucket.org/maproom/qmapshack/downloads/${name}.tar.gz";
    sha256 = "1yp5gw4q4gwiwr9w4dz19am0bhsla9n2l3bdlk98a7f46kxgnkrx";
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
