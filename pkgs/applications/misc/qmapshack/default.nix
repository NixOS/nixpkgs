{ mkDerivation, lib, fetchFromGitHub, cmake
, qtscript, qtwebengine, gdal, proj, routino, quazip }:

mkDerivation rec {
  pname = "qmapshack";
  version = "1.13.2";

  src = fetchFromGitHub {
    owner = "Maproom";
    repo = pname;
    # TODO: remove it on next release.
    # 1.13.2 release tarball is essentially broken, use fixed commit instead.
    # See https://github.com/maproom/qmapshack/pull/4 for more details.
    rev = "763cfc149566325cce9e4690cb7b5f986048f86a"; #"V_${version}";
    sha256 = "1lfivhm9rv9ly1srlmb7d80s77306xplg23lx35vav879bri29rx";
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
    homepage = https://github.com/Maproom/qmapshack;
    description = "Consumer grade GIS software";
    license = licenses.gpl3;
    maintainers = with maintainers; [ dotlambda sikmir ];
    platforms = with platforms; linux;
  };
}
