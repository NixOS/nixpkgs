{ stdenv, fetchurl, gdal, wxGTK30, proj, libiodbc, lzma, jasper,
  libharu, opencv, vigra, postgresql }:

stdenv.mkDerivation rec {
  name = "saga-2.3.1";

  buildInputs = [ gdal wxGTK30 proj libharu opencv vigra postgresql libiodbc lzma jasper ];

  enableParallelBuilding = true;

  src = fetchurl {
    url = "mirror://sourceforge/project/saga-gis/SAGA%20-%202.3/SAGA%202.3.1/saga_2.3.1.tar.gz";
    sha256 = "1h4zkfid9z02mqm1f8az9j0pzmm95f83ra57c4r7bvrrz21w3xaq";
  };

  meta = {
    description = "System for Automated Geoscientific Analyses";
    homepage = http://www.saga-gis.org;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.michelk ];
    platforms = ["x86_64-linux" ];
  };
}
