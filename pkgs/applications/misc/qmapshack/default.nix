{ mkDerivation, lib, fetchurl, fetchpatch, cmake, qtscript, qtwebengine, gdal, proj, routino, quazip }:

mkDerivation rec {
  pname = "qmapshack";
  version = "1.13.1";

  src = fetchurl {
    url = "https://bitbucket.org/maproom/qmapshack/downloads/${pname}-${version}.tar.gz";
    sha256 = "15x1b2q0hr1vx006f9hjc4cvfjvxvfdwybw32qvczdyc3crq0mc9";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ qtscript qtwebengine gdal proj routino quazip ];

  cmakeFlags = [
    "-DROUTINO_XML_PATH=${routino}/share/routino"
    "-DQUAZIP_INCLUDE_DIR=${quazip}/include/quazip5"
    "-DLIBQUAZIP_LIBRARY=${quazip}/lib/libquazip.so"
  ];

  enableParallelBuilding = true;

  patches = [
    (fetchpatch {
      url = "https://bitbucket.org/maproom/qmapshack/raw/d0b1b595578a83fda981ccc1ff24166fa636ba1d/FindPROJ4.patch";
      sha256 = "1nx4ax233bnnj478cmjpm5c1qqmyn1navlihf10q6hhbanay9n99";
    })
    (fetchpatch {
      url = "https://bitbucket.org/maproom/qmapshack/raw/d0b1b595578a83fda981ccc1ff24166fa636ba1d/FindQuaZip5.patch";
      sha256 = "0z1b2dz2zlz685mxgn8bmh1fyhxpf6dzd6jvkkjyk2kvnrdxv3b9";
    })
  ];

  meta = with lib; {
    homepage = https://bitbucket.org/maproom/qmapshack/wiki/Home;
    description = "Plan your next outdoor trip";
    license = licenses.gpl3;
    maintainers = with maintainers; [ dotlambda ];
    platforms = with platforms; linux;
  };
}
