{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, qtbase
, obs-studio
, asio_1_10
, websocketpp
}:

stdenv.mkDerivation rec {
  pname = "obs-websocket";
  version = "4.9.0";

  src = fetchFromGitHub {
    owner = "Palakis";
    repo = "obs-websocket";
    rev = version;
    sha256 = "1dxih5czcfs1vczbq48784jvmgs8awbsrwk8mdfi4pg8n577cr1w";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ qtbase obs-studio asio_1_10 websocketpp ];

  dontWrapQtApps = true;

  cmakeFlags = [
    "-DLIBOBS_INCLUDE_DIR=${obs-studio.src}/libobs"
  ];

  meta = with lib; {
    description = "Remote-control OBS Studio through WebSockets";
    homepage = "https://github.com/Palakis/obs-websocket";
    maintainers = with maintainers; [ erdnaxe ];
    license = licenses.gpl2Plus;
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
