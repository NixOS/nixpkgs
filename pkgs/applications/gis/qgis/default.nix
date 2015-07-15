{ stdenv, fetchurl, gdal, cmake, qt4, flex, bison, proj, geos, x11, sqlite, gsl,
  pyqt4, qwt, fcgi, pythonPackages, libspatialindex, libspatialite, qscintilla, postgresql, makeWrapper }:

stdenv.mkDerivation rec {
  name = "qgis-2.10.0";

  buildInputs = [ gdal qt4 flex bison proj geos x11 sqlite gsl pyqt4 qwt qscintilla
    fcgi libspatialindex libspatialite postgresql ] ++
    (with pythonPackages; [ numpy psycopg2 ]);

  nativeBuildInputs = [ cmake makeWrapper ];

  # fatal error: ui_qgsdelimitedtextsourceselectbase.h: No such file or directory
  #enableParallelBuilding = true;

  # To handle the lack of 'local' RPATH; required, as they call one of
  # their built binaries requiring their libs, in the build process.
  preBuild = ''
    export LD_LIBRARY_PATH=`pwd`/output/lib:$LD_LIBRARY_PATH
  '';

  src = fetchurl {
    url = "http://qgis.org/downloads/${name}.tar.bz2";
    sha256 = "07f9b73bc95e8ec5c69249842c2680634deb57515389268b42dccc6b2f6fd0d7";
  };

  postInstall = ''
    wrapProgram $out/bin/qgis \
      --prefix PYTHONPATH : $PYTHONPATH
  '';

  meta = {
    description = "User friendly Open Source Geographic Information System";
    homepage = http://www.qgis.org;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = with stdenv.lib.platforms; linux;
    maintainers = with stdenv.lib.maintainers; [viric];
  };
}
