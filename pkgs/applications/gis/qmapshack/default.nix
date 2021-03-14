{ mkDerivation, lib, fetchFromGitHub, cmake
, qtscript, qtwebengine, gdal, proj, routino, quazip }:

mkDerivation rec {
  pname = "qmapshack";
  version = "1.15.2";

  src = fetchFromGitHub {
    owner = "Maproom";
    repo = pname;
    rev = "V_${version}";
    sha256 = "1l1j2axf94pdqwirwwhwy3y6k8v1aix78ifqbv6j8sv131h2j7y7";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ qtscript qtwebengine gdal proj routino quazip ];

  cmakeFlags = [
    "-DROUTINO_XML_PATH=${routino}/share/routino"
    "-DQUAZIP_INCLUDE_DIR=${quazip}/include/quazip5"
    "-DLIBQUAZIP_LIBRARY=${quazip}/lib/libquazip.so"
  ];

  patches = [
    "${src}/FindPROJ4.patch"
    "${src}/FindQuaZip5.patch"
  ];

  qtWrapperArgs = [
    "--suffix PATH : ${lib.makeBinPath [ gdal routino ]}"
  ];

  meta = with lib; {
    homepage = "https://github.com/Maproom/qmapshack";
    description = "Consumer grade GIS software";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda sikmir ];
    platforms = with platforms; linux;
  };
}
