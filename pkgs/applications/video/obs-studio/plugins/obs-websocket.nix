{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, qtbase
, qtsvg
, obs-studio
, asio_1_10
, websocketpp
, nlohmann_json
}:

stdenv.mkDerivation rec {
  pname = "obs-websocket";

  # We have updated to the alpha version when OBS Studio 27.2 was
  # released, because this is the only version of obs-websocket that
  # builds against the new OBS Studio.
  version = "5.0.0-alpha3";

  src = fetchFromGitHub {
    owner = "Palakis";
    repo = "obs-websocket";
    rev = version;
    sha256 = "Lr6SBj5rRTAWmn9Tnlu4Sl7SAkOCRCTP6sFWSp4xB+I=";
    fetchSubmodules = true;
  };

  patches = [
    # This patch can be dropped when obs-websocket is updated to the
    # next version.
    (fetchpatch {
      url = "https://github.com/obsproject/obs-websocket/commit/13c7b83c34eb67b2ee80af05071d81f10d0d2997.patch";
      sha256 = "TNap/T8+058vhfWzRRr4vmlblFk9tHMUNyG6Ob5PwiM=";
      name = "obs-addref-werror-fix.patch";
    })
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    qtbase
    qtsvg
    obs-studio
    asio_1_10
    websocketpp
    nlohmann_json
  ];

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
