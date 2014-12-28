{ stdenv, fetchurl, gdal, cmake, qt4, flex, bison, proj, geos, x11, sqlite, gsl,
  pyqt4, qwt, fcgi, python, libspatialindex, libspatialite }:

stdenv.mkDerivation rec {
  name = "qgis-2.4.0";

  buildInputs = [ gdal qt4 flex bison proj geos x11 sqlite gsl pyqt4 qwt
    fcgi libspatialindex libspatialite ];

  nativeBuildInputs = [ cmake python ];

  # fatal error: ui_qgsdelimitedtextsourceselectbase.h: No such file or directory
  #enableParallelBuilding = true;

  # To handle the lack of 'local' RPATH; required, as they call one of
  # their built binaries requiring their libs, in the build process.
  preBuild = ''
    export LD_LIBRARY_PATH=`pwd`/output/lib:$LD_LIBRARY_PATH
  '';

  src = fetchurl {
    url = "http://qgis.org/downloads/${name}.tar.bz2";
    sha256 = "711b7d81ddff45b083a21f05c8aa5093a6a38a0ee42dfcc873234fcef1fcdd76";
    

  };

  meta = {
    description = "User friendly Open Source Geographic Information System";
    homepage = http://www.qgis.org;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = with stdenv.lib.platforms; linux;
    maintainers = with stdenv.lib.maintainers; [viric];
  };
}
