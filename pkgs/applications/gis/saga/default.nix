{ stdenv, fetchurl, gdal, wxGTK30, proj, libiodbc, lzma, jasper,
  libharu, opencv, vigra, postgresql }:

stdenv.mkDerivation rec {
  name = "saga-2.2.2";

  buildInputs = [ gdal wxGTK30 proj libharu opencv vigra postgresql libiodbc lzma jasper ];

  enableParallelBuilding = true;

  src = fetchurl {
    url = "mirror://sourceforge/project/saga-gis/SAGA%20-%202.2/SAGA%202.2.2/saga-2.2.2.tar.gz";
    sha256 = "031cd70b7ec248f32f955a9316aefc7f7ab283c5129c49aa4bd748717d20357e";
  };

  meta = {
    description = "System for Automated Geoscientific Analyses";
    homepage = http://www.saga-gis.org;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.michelk ];
    platforms = ["x86_64-linux" ];
  };
}
