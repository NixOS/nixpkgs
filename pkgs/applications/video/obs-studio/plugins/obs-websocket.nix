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
  version = "4.9.1";

  src = fetchFromGitHub {
    owner = "Palakis";
    repo = "obs-websocket";
    rev = version;
    sha256 = "sha256-XCiSNWTiA/u+3IbYlhIc5bCjKjLHDRVjYIG5MEoYnr0=";
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
