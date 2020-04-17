{ mkDerivation, lib, fetchFromGitHub, cmake
, qtscript, qtwebengine, gdal, proj, routino, quazip }:

mkDerivation rec {
  pname = "qmapshack";
  version = "1.14.1";

  src = fetchFromGitHub {
    owner = "Maproom";
    repo = pname;
    rev = "V_${version}";
    sha256 = "0hghynb4ac98fg1pwc645zriqkghxwp8mr3jhr87pa6fh0y848py";
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
    "${src}/FindPROJ4.patch"
    "${src}/FindQuaZip5.patch"
  ];

  meta = with lib; {
    homepage = "https://github.com/Maproom/qmapshack";
    description = "Consumer grade GIS software";
    license = licenses.gpl3;
    maintainers = with maintainers; [ dotlambda sikmir ];
    platforms = with platforms; linux;
  };
}
