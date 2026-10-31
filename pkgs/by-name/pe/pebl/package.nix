{
  lib,
  clangStdenv,
  fetchFromGitHub,
  SDL2,
  SDL2_ttf,
  SDL2_image,
  SDL2_mixer,
  SDL2_net,
  SDL2_gfx,
  curl,
  libpng,
}:

clangStdenv.mkDerivation (finalAttrs: {
  pname = "pebl";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "stmueller";
    repo = "pebl";
    tag = finalAttrs.version;
    hash = "sha256-5BJUY4HHcWSzkPEuZRY9eguLJT5OTVMMqzzcnB9XSts=";
  };

  buildInputs = [
    SDL2
    SDL2_ttf
    SDL2_image
    SDL2_mixer
    SDL2_net
    SDL2_gfx
    curl
    libpng
  ];

  env.NIX_CFLAGS_COMPILE = ''
    -I${lib.getInclude SDL2}/include/SDL2
    -I${SDL2_ttf}/include/SDL2
    -I${SDL2_image}/include/SDL2
    -I${lib.getInclude SDL2_mixer}/include/SDL2
    -I${lib.getInclude SDL2_net}/include/SDL2
    -I${lib.getInclude SDL2_gfx}/include/SDL2
    -I${lib.getInclude curl}/include
  '';

  installFlags = [ "PREFIX=${placeholder "out"}/" ];

  meta = {
    description = "Free cross-platform system for designing psychological experiments";
    license = lib.licenses.gpl2Plus;
    mainProgram = "pebl2";
    maintainers = with lib.maintainers; [ sauricat ];
    platforms = lib.platforms.linux;
  };
})
