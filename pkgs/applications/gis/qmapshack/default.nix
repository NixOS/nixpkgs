{ lib, stdenv, fetchFromGitHub, cmake, wrapQtAppsHook
, qtscript, qtwebengine, gdal, proj, routino, quazip }:

stdenv.mkDerivation rec {
  pname = "qmapshack";
  version = "1.17.0";

  src = fetchFromGitHub {
    owner = "Maproom";
    repo = "qmapshack";
    rev = "V_${version}";
    hash = "sha256-qG/fiR2J5wQZaR+xvBGjdp3L7viqki2ktkzBUf6fZi8=";
  };

  nativeBuildInputs = [ cmake wrapQtAppsHook ];

  buildInputs = [ qtscript qtwebengine gdal proj routino quazip ];

  cmakeFlags = [
    "-DROUTINO_XML_PATH=${routino}/share/routino"
  ];

  qtWrapperArgs = [
    "--suffix PATH : ${lib.makeBinPath [ gdal routino ]}"
  ];

  meta = with lib; {
    description = "Consumer grade GIS software";
    homepage = "https://github.com/Maproom/qmapshack";
    changelog = "https://github.com/Maproom/qmapshack/blob/V_${version}/changelog.txt";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda sikmir ];
    platforms = with platforms; linux;
  };
}
