{
  lib,
  SDL2,
  SDL2_image,
  SDL2_mixer,
  SDL2_ttf,
  directoryListingUpdater,
  fetchurl,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lpairs2";
  version = "2.3.1";

  src = fetchurl {
    url = "mirror://sourceforge/lgames/lpairs2-${finalAttrs.version}.tar.gz";
    hash = "sha256-ES5RGr817vc8t2DFNeETTqrm0uwk3JuTypSZjXK86Bg=";
  };

  buildInputs = [
    SDL2
    SDL2_image
    SDL2_mixer
    SDL2_ttf
  ];

  passthru.updateScript = directoryListingUpdater {
    inherit (finalAttrs) pname version;
    url = "https://lgames.sourceforge.io/LPairs/";
    extraRegex = "(?!.*-win(32|64)).*";
  };

  meta = {
    homepage = "http://lgames.sourceforge.net/LPairs/";
    description = "Matching the pairs - a typical Memory Game";
    license = with lib.licenses; [ gpl2Plus ];
    mainProgram = "lpairs2";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.unix;
    broken = stdenv.isDarwin;
  };
})
