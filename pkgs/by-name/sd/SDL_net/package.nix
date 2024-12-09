{
  lib,
  SDL,
  fetchurl,
  pkg-config,
  stdenv,
  # Boolean flags
  enableSdltest ? (!stdenv.hostPlatform.isDarwin)
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "SDL_net";
  version = "1.2.8";

  src = fetchurl {
    url = "http://www.libsdl.org/projects/SDL_net/release/SDL_net-${finalAttrs.version}.tar.gz";
    hash = "sha256-X0p6i7iE95PCeKw/NxO+QZgMXu3M7P8CYEETR3FPrLQ=";
  };

  nativeBuildInputs = [
    SDL
    pkg-config
  ];

  propagatedBuildInputs = [
    SDL
  ];

  configureFlags = [
    (lib.enableFeature enableSdltest "sdltest")
  ];

  strictDeps = true;

  meta = {
    homepage = "https://github.com/libsdl-org/SDL_net";
    description = "SDL networking library";
    license = lib.licenses.zlib;
    maintainers =  lib.teams.sdl.members
                   ++ (with lib.maintainers; [ ]);
    inherit (SDL.meta) platforms;
  };
})
