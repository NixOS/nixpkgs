{ lib
, stdenv
, fetchFromGitHub
, cmake
, qt6
}:

stdenv.mkDerivation rec {
  pname = "KDSingleApplication";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "KDAB";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-5YprRbfiFI2UGMJqDf+3VDwXV904USEpMEpoNm0g7KY=";
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
