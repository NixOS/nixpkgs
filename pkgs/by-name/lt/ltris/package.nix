{
  lib,
  SDL,
  SDL_mixer,
  directoryListingUpdater,
  fetchurl,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lgames-ltris";
  version = "1.2.8";

  src = fetchurl {
    url = "mirror://sourceforge/lgames/ltris-${finalAttrs.version}.tar.gz";
    hash = "sha256-2e5haaU2pqkBk82qiF/3HQgSBVPHP09UwW+TQqpGUqA=";
  };

  buildInputs = [
    SDL
    SDL_mixer
  ];

  hardeningDisable = [ "format" ];

  passthru.updateScript = directoryListingUpdater {
    inherit (finalAttrs) pname version;
    url = "https://lgames.sourceforge.io/LTris/";
    extraRegex = "(?!.*-win(32|64)).*";
  };

  meta = {
    homepage = "https://lgames.sourceforge.io/LTris/";
    description = "Tetris clone from the LGames series";
    license = with lib.licenses; [ gpl2Plus ];
    mainProgram = "ltris";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    inherit (SDL.meta) platforms;
    broken = stdenv.hostPlatform.isDarwin;
  };
})
