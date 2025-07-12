{
  lib,
  sdl2-compat,
  SDL2_mixer,
  SDL2_image,
  SDL2_ttf,
  directoryListingUpdater,
  fetchurl,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ltris";
  version = "2.0.3";

  src = fetchurl {
    url = "mirror://sourceforge/lgames/ltris2-${finalAttrs.version}.tar.gz";
    hash = "sha256-+w8WTASYj/AWcBg9W3dmZ0cyCmlZNhDZ0l/WwhRfJRk=";
  };

  buildInputs = [
    sdl2-compat
    SDL2_mixer
    SDL2_image
    SDL2_ttf
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
    license = with lib.licenses; [ gpl3Plus ];
    mainProgram = "ltris2";
    maintainers = with lib.maintainers; [ marcin-serwin ];
    platforms = lib.platforms.all;
    broken = stdenv.hostPlatform.isDarwin;
  };
})
