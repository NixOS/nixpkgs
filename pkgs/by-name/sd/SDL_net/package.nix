{
  lib,
  SDL,
  fetchFromGitHub,
  pkg-config,
  stdenv,
  unstableGitUpdater,
  # Boolean flags
  enableSdltest ? (!stdenv.hostPlatform.isDarwin),
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "SDL_net";
  version = "1.2.8-unstable-2026-03-17";

  src = fetchFromGitHub {
    owner = "libsdl-org";
    repo = "SDL_net";
    rev = "cd5a2ebdea1a15b27f503cc7ffdcaf056d047b73";
    hash = "sha256-z3bJYf3PzS0ydoeL0Ay0HOZ9ImKZMyLbVZhD+u5BD6w=";
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

  passthru.updateScript = unstableGitUpdater {
    tagFormat = "release-1.*";
    tagPrefix = "release-";
    branch = "SDL-1.2";
  };

  meta = {
    homepage = "https://github.com/libsdl-org/SDL_net";
    description = "SDL networking library";
    license = lib.licenses.zlib;
    teams = [ lib.teams.sdl ];
    inherit (SDL.meta) platforms;
  };
})
