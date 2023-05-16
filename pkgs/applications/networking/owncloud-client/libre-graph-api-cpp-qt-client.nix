{ lib
, stdenv
, fetchFromGitHub
, cmake
, qtbase
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "libre-graph-api-cpp-qt-client";
<<<<<<< HEAD
  version = "1.0.4";
=======
  version = "0.13.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "owncloud";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-wbdamPi2XSLWeprrYZtBUDH1A2gdp6/5geFZv+ZqSWk=";
  };

  sourceRoot = "${src.name}/client";
=======
    hash = "sha256-gbrA8P+ukQAiF2czC2szw3fJv1qoPJyMQ72t7PqB5/s=";
  };

  sourceRoot = "source/client";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ cmake wrapQtAppsHook ];
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
