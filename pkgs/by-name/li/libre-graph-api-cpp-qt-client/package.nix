{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libre-graph-api-cpp-qt-client";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "owncloud";
    repo = "libre-graph-api-cpp-qt-client";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wbdamPi2XSLWeprrYZtBUDH1A2gdp6/5geFZv+ZqSWk=";
  };

  sourceRoot = "source/client";

  nativeBuildInputs = [ cmake ];
  buildInputs = [ qt6.qtbase ];
  dontWrapQtApps = true;

  meta = {
    description = "C++ Qt API for Libre Graph, a free API for cloud collaboration inspired by the MS Graph API";
    homepage = "https://owncloud.org";
    maintainers = [ lib.maintainers.hellwolf lib.maintainers.timoteuszelle ];
    platforms = lib.platforms.unix;
    license = lib.licenses.asl20;
    changelog = "https://github.com/owncloud/libre-graph-api-cpp-qt-client/releases/tag/v${finalAttrs.version}";
  };
})
