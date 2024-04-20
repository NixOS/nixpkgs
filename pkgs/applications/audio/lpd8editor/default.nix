{ lib
, qt5
, stdenv
, git
, fetchFromGitHub
, cmake
, alsa-lib
, qttools
}:

stdenv.mkDerivation rec {
  pname = "lpd8editor";
  version = "0.0.16";

  src = fetchFromGitHub {
    owner = "charlesfleche";
    repo = "lpd8editor";
    rev = "v${version}";
    hash = "sha256-lRp2RhNiIf1VrryfKqYFSbKG3pktw3M7B49fXVoj+C8=";
  };

  buildInputs = [
    qttools
    alsa-lib
  ];

  nativeBuildInputs = [
    cmake
    git
    qt5.wrapQtAppsHook
  ];

  meta = with lib; {
    description = "A linux editor for the Akai LPD8";
    homepage = "https://github.com/charlesfleche/lpd8editor";
    license = licenses.mit;
    maintainers = with maintainers; [ pinpox ];
    mainProgram = "lpd8editor";
    platforms = platforms.all;
  };
}
