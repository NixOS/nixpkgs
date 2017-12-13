{ stdenv, fetchFromBitbucket, cmake, qtscript, qtwebkit, gdal, proj, routino, quazip }:

stdenv.mkDerivation rec {
  name = "qmapshack-${version}";
  version = "1.9.1";

  src = fetchFromBitbucket {
    owner = "maproom";
    repo = "qmapshack";
    rev = "V%20${version}";
    sha256 = "1yswdq1s9jjhwb3wfiy3kkiiaqzagw28vjqvl13jxcnmq7y763sr";
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
