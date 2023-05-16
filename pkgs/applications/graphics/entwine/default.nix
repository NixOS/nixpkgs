{ lib
, stdenv
, fetchFromGitHub
, cmake
, pdal
, curl
, openssl
}:

<<<<<<< HEAD
stdenv.mkDerivation {
  pname = "entwine";
  version = "unstable-2023-04-27";
=======
stdenv.mkDerivation rec {
  pname = "entwine";
  version = "unstable-2022-08-03";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "connormanning";
    repo = "entwine";
<<<<<<< HEAD
    rev = "8bd179c38e6da1688f42376b88ff30427672c4e3";
    sha256 = "sha256-RlNxTtqxQoniI1Ugj5ot0weu7ji3WqDJZpMu2n8vBkw=";
=======
    rev = "c776d51fd6ab94705b74f78b26de7f853e6ceeae";
    sha256 = "sha256-dhYJhXtfMmqQLWuV3Dux/sGTsVxCI7RXR2sPlwIry0g=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [
    openssl
    pdal
    curl
  ];

  nativeBuildInputs = [
    cmake
  ];

  meta = with lib; {
    description = "Point cloud organization for massive datasets";
    homepage = "https://entwine.io/";
    license = licenses.lgpl2Only;
    maintainers = with maintainers; [ matthewcroughan ];
    platforms = platforms.linux;
  };
}
