{ stdenv, fetchurl, gdal, wxGTK30, proj, libiodbc, lzma, jasper,
  libharu, opencv, vigra, postgresql }:

stdenv.mkDerivation rec {
  name = "saga-2.1.2";

  buildInputs = [ gdal wxGTK30 proj libharu opencv vigra postgresql libiodbc lzma jasper ];

  enableParallelBuilding = true;

  src = fetchurl {
    url = "http://sourceforge.net/projects/saga-gis/files/SAGA%20-%202.1/SAGA%202.1.2/saga_2.1.2.tar.gz";
    sha256 = "51885446f717191210c4b13f0c35a1c5194c9d696d4f9b8f594bc1014809b2f5";
  };

  meta = {
    description = "SAGA - System for Automated Geoscientific Analyses";
    homepage = http://www.saga-gis.org;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.michelk ];
    platforms = with stdenv.lib.platforms; linux;
    broken = true;
  };
}
