{ stdenv, fetchurl, cmake, qtscript, qtwebkit, gdal, proj, routino, quazip }:

stdenv.mkDerivation rec {
  name = "qmapshack-${version}";
  version = "1.10.0";

  src = fetchurl {
    url = "https://bitbucket.org/maproom/qmapshack/downloads/${name}.tar.gz";
    sha256 = "10qk6c5myw5dhkbw7pcrx3900kiqhs32vy47xl2844nzb4fq2liw";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ qtscript qtwebkit gdal proj routino quazip ];

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
