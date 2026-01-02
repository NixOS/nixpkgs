{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "flare-game";
  version = "1.14";

  src = fetchFromGitHub {
    owner = "flareteam";
    repo = "flare-game";
    tag = "v${version}";
    hash = "sha256-tINIwxyQn8eeJCHwRmAMo2TYRgrgJlGaUrnrgbmM3Jo=";
  };

  patches = [
    # cmake-4 compatibility patch
    (fetchpatch {
      name = "cmake-4.patch";
      url = "https://github.com/flareteam/flare-game/commit/5b61dfd69f4ecbaca6439caa9ae41b3168e4d21a.patch";
      hash = "sha256-5Um6LWAWQyialzO3KSebmLju0VOuz1S5dzavO9EWlLE=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Fantasy action RPG using the FLARE engine";
    homepage = "https://github.com/flareteam/flare-game";
    maintainers = with lib.maintainers; [
      aanderse
      McSinyx
    ];
    license = [ lib.licenses.cc-by-sa-30 ];
    platforms = lib.platforms.unix;
  };
}
