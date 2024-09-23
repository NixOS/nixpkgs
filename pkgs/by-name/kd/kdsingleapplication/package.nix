{ lib
, stdenv
, fetchFromGitHub
, cmake
, qt6
}:

stdenv.mkDerivation rec {
  pname = "KDSingleApplication";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "KDAB";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-Ymm+qOZMWULg7u5xEpGzcAfIrbWBQ3jsndnFSnh6/PA=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ qt6.qtbase ];

  cmakeFlags = [ "-DKDSingleApplication_QT6=true" ];
  dontWrapQtApps = true;

  meta = with lib; {
    description = "KDAB's helper class for single-instance policy applications";
    homepage = "https://www.kdab.com/";
    maintainers = with maintainers; [ hellwolf ];
    platforms = platforms.unix;
    license = licenses.mit;
    changelog = "https://github.com/KDAB/KDSingleApplication/releases/tag/v${version}";
  };
}
