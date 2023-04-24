{ lib
, fetchFromGitHub
, mkDerivation
, cmake
, qtbase
}:

mkDerivation rec {
  pname = "libre-graph-api-cpp-qt-client";
  version = "0.13.2";

  src = fetchFromGitHub {
    owner = "owncloud";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-gbrA8P+ukQAiF2czC2szw3fJv1qoPJyMQ72t7PqB5/s=";
  };

  sourceRoot = "source/client";

  nativeBuildInputs = [ cmake ];
  buildInputs = [ qtbase ];

  cmakeFlags = [  ];

  meta = with lib; {
    description = "C++ Qt API for Libre Graph, a free API for cloud collaboration inspired by the MS Graph API";
    homepage = "https://owncloud.org";
    maintainers = with maintainers; [ qknight hellwolf ];
    platforms = platforms.unix;
    license = licenses.asl20;
    changelog = "https://github.com/owncloud/libre-graph-api-cpp-qt-client/releases/tag/v${version}";
  };
}
