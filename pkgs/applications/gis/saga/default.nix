{ stdenv, fetchurl, gdal, wxGTK_3, proj, libiodbc, lzma, jasper,
  libharu, opencv, vigra, postgresql }:

stdenv.mkDerivation rec {
  name = "saga-${version}";
  version = "6.3.0";

  buildInputs = [ gdal wxGTK_3 proj libharu opencv vigra postgresql libiodbc lzma jasper ];

  enableParallelBuilding = true;

  src = fetchurl {
    url = "mirror://sourceforge/project/saga-gis/SAGA%20-%206/SAGA%20-%20${version}/${name}.tar.gz";
    sha256 = "0hyjim8fcp3mna1hig22nnn4ki3j6b7096am2amcs99sdr09jjxv";
  };

  meta = {
    description = "System for Automated Geoscientific Analyses";
    homepage = http://www.saga-gis.org;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.michelk ];
    platforms = ["x86_64-linux" ];
  };
}
