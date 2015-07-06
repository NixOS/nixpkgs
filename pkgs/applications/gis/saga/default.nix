{ stdenv, fetchurl, gdal, wxGTK30, proj, libiodbc, lzma, jasper,
  libharu, opencv, vigra, postgresql }:

stdenv.mkDerivation rec {
  name = "saga-2.2.0";

  buildInputs = [ gdal wxGTK30 proj libharu opencv vigra postgresql libiodbc lzma jasper ];

  enableParallelBuilding = true;

  src = fetchurl {
    url = "http://sourceforge.net/projects/saga-gis/files/SAGA%20-%202.2/SAGA%202.2.0/saga_2.2.0.tar.gz";
    sha256 = "50b2e642331c817606bc954302e53757c4ffa6f6d6f468e12caeaaa7a182edaf";
  };

  meta = {
    description = "System for Automated Geoscientific Analyses";
    homepage = http://www.saga-gis.org;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.michelk ];
    platforms = ["x86_64-linux" ];
  };
}
