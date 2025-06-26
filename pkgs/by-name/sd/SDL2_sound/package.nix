{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  SDL2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "SDL2_sound";
  version = "2.0.4";

  src = fetchFromGitHub {
    owner = "icculus";
    repo = "SDL_sound";
    rev = "v${finalAttrs.version}";
    hash = "sha256-5t2ELm8d8IX+cIJqGl/8sffwXGj5Cm0kZI6+bmjvvPg=";
  };

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    (lib.cmakeBool "SDLSOUND_DECODER_MIDI" true)
    (lib.cmakeBool "SDLSOUND_BUILD_SHARED" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "SDLSOUND_BUILD_STATIC" stdenv.hostPlatform.isStatic)
  ];

  buildInputs = [ SDL2 ];

  meta = {
    description = "SDL2 sound library";
    mainProgram = "playsound";
    platforms = lib.platforms.all;
    license = with lib.licenses; [
      zlib

      # various vendored decoders
      publicDomain

      # timidity
      artistic1
      lgpl21Only
    ];
    teams = [ lib.teams.sdl ];
    homepage = "https://www.icculus.org/SDL_sound/";
  };
})
