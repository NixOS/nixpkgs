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
  pname = "lbreakouthd";
  version = "1.2";

  src = fetchurl {
    url = "mirror://sourceforge/lgames/lbreakouthd-${finalAttrs.version}.tar.gz";
    hash = "sha256-ZEy/b2ZWAZvDNbAu/FnpsPo8WsvSGADbdaSXU/gpdBk=";
  };

  # On macOS with a case-insensitive filesystem, "sdl.h" shadows <SDL.h>
  postPatch = lib.optionalString stdenv.buildPlatform.isDarwin ''
    mv src/sdl.h src/lbhd_sdl.h
    for file in src/*.cpp src/*.h; do
      substituteInPlace "$file" --replace-quiet 'sdl.h' 'lbhd_sdl.h'
    done
  '';

  buildInputs = [
    SDL2
    SDL2_image
    SDL2_mixer
    SDL2_ttf
  ];

  hardeningDisable = [ "format" ];

  passthru.updateScript = directoryListingUpdater {
    inherit (finalAttrs) pname version;
    url = "https://lgames.sourceforge.io/LBreakoutHD/";
    extraRegex = "(?!.*-win(32|64)).*";
  };

  meta = {
    homepage = "https://lgames.sourceforge.io/LBreakoutHD/";
    description = "Widescreen Breakout clone";
    license = lib.licenses.gpl2Plus;
    mainProgram = "lbreakouthd";
    maintainers = [ ];
    inherit (SDL2.meta) platforms;
  };
})
