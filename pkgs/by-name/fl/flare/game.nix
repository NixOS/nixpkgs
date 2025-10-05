{
  lib,
  stdenv,
  fetchFromGitHub,
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
