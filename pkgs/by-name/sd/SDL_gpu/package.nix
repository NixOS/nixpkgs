{
  lib,
  SDL2,
  cmake,
  fetchFromGitHub,
  libGLU,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "SDL_gpu";
  version = "0-unstable-2022-06-24";

  src = fetchFromGitHub {
    owner = "grimfang4";
    repo = "sdl-gpu";
    rev = "e8ee3522ba0dbe72ca387d978e5f49a9f31e7ba0";
    hash = "sha256-z1ZuHh9hvno2h+kCKfe+uWa/S6/OLZWWgLZ0zs9HetQ=";
  };

  nativeBuildInputs = [
    SDL2
    cmake
    pkg-config
  ];

  buildInputs = [
    SDL2
    libGLU
  ];

  cmakeFlags = [
    (lib.cmakeBool "SDL_gpu_BUILD_DEMOS" false)
    (lib.cmakeBool "SDL_gpu_BUILD_TOOLS" false)
    (lib.cmakeBool "SDL_gpu_BUILD_VIDEO_TEST" false)
    (lib.cmakeBool "SDL_gpu_BUILD_TESTS" false)
  ];

  outputs = [ "out" "dev" ];

  strictDeps = true;

  meta = {
    description = "A library for high-performance, modern 2D graphics with SDL written in C";
    homepage = "https://grimfang4.github.io/sdl-gpu";
    license = lib.licenses.mit;
    maintainers = lib.teams.sdl.members
                  ++ (with lib.maintainers; [ ]);
    inherit (SDL2.meta) platforms;
  };
})
