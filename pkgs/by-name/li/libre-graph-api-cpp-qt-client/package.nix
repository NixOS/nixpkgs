{ lib
, stdenv
, fetchFromGitHub
, cmake
, qt6
}:

stdenv.mkDerivation rec {
  pname = "libre-graph-api-cpp-qt-client";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "owncloud";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-wbdamPi2XSLWeprrYZtBUDH1A2gdp6/5geFZv+ZqSWk=";
  };

  sourceRoot = "${src.name}/client";

  nativeBuildInputs = [ cmake ];
  buildInputs = [ qt6.qtbase ];
  dontWrapQtApps = true;

  meta = with lib; {
    description = "C++ Qt API for Libre Graph, a free API for cloud collaboration inspired by the MS Graph API";
    homepage = "https://owncloud.org";
    maintainers = with maintainers; [ hellwolf ];
    platforms = platforms.unix;
    license = licenses.asl20;
    changelog = "https://github.com/owncloud/libre-graph-api-cpp-qt-client/releases/tag/v${version}";
  };
}
