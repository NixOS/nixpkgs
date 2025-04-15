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
  version = "1.2.8-unstable-2024-04-23";

  src = fetchFromGitHub {
    owner = "libsdl-org";
    repo = "SDL_net";
    rev = "0043be2e559f8d562d04bf62d6e3f4162ed8edad";
    hash = "sha256-/W1Mq6hzJNNwpcx+VUT4DRGP3bE06GGMbYDGHBc4XlQ=";
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
    maintainers = lib.teams.sdl.members ++ (with lib.maintainers; [ ]);
    inherit (SDL.meta) platforms;
  };
})
