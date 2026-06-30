{
  lib,
  SDL,
  SDL_mixer,
  fetchurl,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "barrage";
  version = "1.0.8";

  src = fetchurl {
    url = "mirror://sourceforge/lgames/barrage-${finalAttrs.version}.tar.gz";
    hash = "sha256-9mdC7JiZPGnjj9+h4jezIY2AL0X096MxzTwlwH1zYT8=";
  };

  postPatch = ''
    substituteInPlace src/main.c \
      --replace-fail "void refresh_screen()" "void refresh_screen(SDL_Surface *screen)"
  '';

  buildInputs = [
    SDL
    SDL_mixer
  ];

  hardeningDisable = [ "format" ];

  meta = {
    homepage = "https://lgames.sourceforge.io/Barrage/";
    description = "Destructive action game";
    license = with lib.licenses; [ gpl2Plus ];
    mainProgram = "barrage";
    maintainers = [ ];
    inherit (SDL.meta) platforms;
    broken = stdenv.hostPlatform.isDarwin;
  };
})
