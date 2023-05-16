{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, qttools
, qtbase
}:

mkDerivation rec {
  pname = "heimer";
<<<<<<< HEAD
  version = "4.2.0";
=======
  version = "4.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "juzzlin";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-Z94e+4WwabHncBr4Gsv0AkZHyrbFCCIpumGbANHX6dU=";
=======
    hash = "sha256-cq8rRz1mfDPzTRVG++vccI2YewSKQqd1RAJbgB3TS5E=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    qttools
    qtbase
  ];

  meta = with lib; {
    description = "Simple cross-platform mind map and note-taking tool written in Qt";
    homepage = "https://github.com/juzzlin/Heimer";
    changelog = "https://github.com/juzzlin/Heimer/blob/${version}/CHANGELOG";
    license = licenses.gpl3Plus;
    maintainers  = with maintainers; [ dtzWill ];
    platforms = platforms.linux;
  };
}
