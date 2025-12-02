{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
}:

stdenv.mkDerivation rec {
  pname = "libre-graph-api-cpp-qt-client";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "owncloud";
    repo = "libre-graph-api-cpp-qt-client";
    tag = "v${version}";
    hash = "sha256-wbdamPi2XSLWeprrYZtBUDH1A2gdp6/5geFZv+ZqSWk=";
  };

  sourceRoot = "${src.name}/client";

  # cmake 4 compatibility
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.4)" "cmake_minimum_required(VERSION 3.10)"
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [ qt6.qtbase ];
  dontWrapQtApps = true;

  meta = {
    description = "C++ Qt API for Libre Graph, a free API for cloud collaboration inspired by the MS Graph API";
    homepage = "https://owncloud.org";
    maintainers = with lib.maintainers; [ hellwolf ];
    platforms = lib.platforms.unix;
    license = lib.licenses.asl20;
    changelog = "https://github.com/owncloud/libre-graph-api-cpp-qt-client/releases/tag/v${version}";
  };
}
