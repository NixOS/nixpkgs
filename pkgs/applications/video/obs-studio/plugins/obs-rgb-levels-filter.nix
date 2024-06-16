{ lib
, stdenv
, fetchFromGitHub
, cmake
, obs-studio
}:

stdenv.mkDerivation rec {
  pname = "obs-rgb-levels-filter";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "wimpysworld";
    repo = "obs-rgb-levels-filter";
    rev = version;
    sha256 = "sha256-QREwK9nBhjCBFslXUj9bGUGPgfEns8QqlgP5e2O/0oU=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ obs-studio ];

  cmakeFlags = [
    "-DOBS_SRC_DIR=${obs-studio.src}"
  ];

  meta = with lib; {
    description = "A simple OBS Studio filter to adjust RGB levels";
    homepage = "https://github.com/wimpysworld/obs-rgb-levels-filter";
    maintainers = with maintainers; [ flexiondotorg ];
    license = licenses.gpl2Plus;
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
