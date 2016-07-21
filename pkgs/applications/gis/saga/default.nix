{ stdenv, fetchurl, gdal, wxGTK30, proj, libiodbc, lzma, jasper,
  libharu, opencv, vigra, postgresql }:

stdenv.mkDerivation rec {
  name = "saga-2.3.1";

  buildInputs = [ gdal wxGTK30 proj libharu opencv vigra postgresql libiodbc lzma jasper ];

  enableParallelBuilding = true;

  src = fetchurl {
    url = "mirror://sourceforge.net/project/saga-gis/SAGA%20-%202.3/SAGA%202.3.1/saga_2.3.1.tar.gz";
    sha256 = "58f5c183f839ef753261a7a83c902ba9d67f814c5f21172aae02fcd4a29b9fc0";
  };

  meta = {
    description = "System for Automated Geoscientific Analyses";
    homepage = http://www.saga-gis.org;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.michelk ];
    platforms = ["x86_64-linux" ];
  };
}
