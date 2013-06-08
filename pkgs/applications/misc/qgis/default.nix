{ stdenv, fetchurl, gdal, cmake, qt4, flex, bison, proj, geos, x11, sqlite, gsl,
  pyqt4, qwt, fcgi, python }:

stdenv.mkDerivation rec {
  name = "qgis-1.6.0";

  buildInputs = [ gdal qt4 flex bison proj geos x11 sqlite gsl pyqt4 qwt
    fcgi ];

  nativeBuildInputs = [ cmake python];

  patches = [ ./r14988.diff ];

  src = fetchurl {
    url = "http://qgis.org/downloads/${name}.tar.bz2";
    sha256 = "0vlz1z3scj3k6nxf3hzfiq7k2773i6xvk6dvj4axs2f4njpnx7pr";
  };

  meta = {
    description = "user friendly Open Source Geographic Information System";
    homepage = ttp://www.qgis.org;
    # you can choose one of the following licenses:
    license = [ "GPL" ];
  };
}
