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

clangStdenv.mkDerivation rec {
  pname = "pebl";
  version = "2.3.0";
  src = fetchFromGitHub {
    owner = "stmueller";
    repo = pname;
    rev = version;
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
    -I${SDL2.dev}/include/SDL2
    -I${SDL2_ttf}/include/SDL2
    -I${SDL2_image}/include/SDL2
    -I${SDL2_mixer.dev}/include/SDL2
    -I${SDL2_net.dev}/include/SDL2
    -I${SDL2_gfx.dev}/include/SDL2
    -I${curl.dev}/include
  '';

  installFlags = [ "PREFIX=${placeholder "out"}/" ];

  meta = {
    description = "Psychology Experiment Building Language";
    license = lib.licenses.gpl2;
    mainProgram = "pebl2";
    maintainers = with lib.maintainers; [ sauricat ];
    platforms = [ "x86_64-linux" ];
  };
}
