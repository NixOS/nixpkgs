{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  SDL2,
  SDL2_image,
  SDL2_mixer,
  SDL2_ttf,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "flare-engine";
  version = "1.15";

  src = fetchFromGitHub {
    owner = "flareteam";
    repo = "flare-engine";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QwrSMkJE8dNIODlmdi1c6qgTULhJP9HEV8wI7k5vHAA=";
  };

  patches = [
    ./desktop.patch
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    SDL2
    SDL2_image
    SDL2_mixer
    SDL2_ttf
  ];

  meta = {
    description = "Free/Libre Action Roleplaying Engine";
    homepage = "https://github.com/flareteam/flare-engine";
    maintainers = with lib.maintainers; [
      aanderse
      McSinyx
    ];
    license = [ lib.licenses.gpl3Plus ];
    platforms = lib.platforms.unix;
  };
})
