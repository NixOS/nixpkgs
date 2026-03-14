{
  lib,
  fetchFromGitHub,
  stdenv,
  cmake,
  obs-studio,
}:

stdenv.mkDerivation rec {
  pname = "obs-image-reaction";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "scaledteam";
    repo = "obs-image-reaction";
    rev = "${version}";
    sha256 = "sha256-WuzcI9+5ql3mz7n9adUKgoop8uTO7YTBrGCggCnjcc0=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ obs-studio ];

  patches = [
    ./libobs-is-case-sensitive.patch
    ./fix-include-directories.patch
  ];

  cmakeFlags = [
    "-DLibObs_DIR=${obs-studio.src}/libobs"
    "-DOBS_INCLUDE_DIR=${obs-studio}/include/obs"
    "-DLIBOBS_INCLUDE_DIR=${obs-studio.src}/libobs"
    "-DOBS_FRONTEND_API_INCLUDE_DIR=${obs-studio.src}/frontend/api"
  ];

  installPhase = ''
    PLUGIN_ROOT="$out/lib/obs-plugins/obs-image-reaction"
    PLUGIN_BIN_DIR="$PLUGIN_ROOT/bin/64bit"
    mkdir -p "$PLUGIN_BIN_DIR"
    mv libimage-reaction.so "$PLUGIN_BIN_DIR/"
    mv ../data "$PLUGIN_ROOT/"
  '';

  meta = {
    description = "OBS Studio plugin for adding an image that reacts to a sound source";
    homepage = "https://github.com/scaledteam/obs-image-reaction";
    license = with lib.licenses; [
      gpl2
    ];
    maintainers = [ lib.maintainers.codebam ];
    inherit (obs-studio.meta) platforms;
  };
}
