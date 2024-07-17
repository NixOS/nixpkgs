{
  lib,
  SDL,
  SDL_mixer,
  fetchurl,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "barrage";
  version = "1.0.7";

  src = fetchurl {
    url = "mirror://sourceforge/lgames/barrage-${finalAttrs.version}.tar.gz";
    hash = "sha256-cGYrG7A4Ffh51KyR+UpeWu7A40eqxI8g4LefBIs18kg=";
  };

  buildInputs = [
    SDL
    SDL_mixer
  ];

  hardeningDisable = [ "format" ];

  meta = {
    homepage = "https://lgames.sourceforge.io/Barrage/";
    description = "A destructive action game";
    license = with lib.licenses; [ gpl2Plus ];
    mainProgram = "barrage";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    inherit (SDL.meta) platforms;
    broken = stdenv.isDarwin;
  };
})
