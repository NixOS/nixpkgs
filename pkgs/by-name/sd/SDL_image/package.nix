{
  lib,
  SDL,
  fetchFromGitHub,
  giflib,
  libxpm,
  libjpeg,
  libpng,
  libtiff,
  libwebp,
  pkg-config,
  stdenv,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "SDL_image";
  version = "1.2.12-unstable-2026-04-29";

  src = fetchFromGitHub {
    owner = "libsdl-org";
    repo = "SDL_image";
    rev = "5e690c3ff429025386837c4ff38e1761cd5e1d72";
    hash = "sha256-BZz35PPW3UXfSyQEbYzpLD2HIZ+hCmDNVvvRypmecQY=";
  };

  configureFlags = [
    # Disable dynamic loading or else dlopen will fail because of no proper
    # rpath
    (lib.enableFeature false "jpg-shared")
    (lib.enableFeature false "png-shared")
    (lib.enableFeature false "tif-shared")
    (lib.enableFeature false "webp-shared")
    (lib.enableFeature (!stdenv.hostPlatform.isDarwin) "sdltest")
  ];

  nativeBuildInputs = [
    SDL
    pkg-config
  ];

  buildInputs = [
    SDL
    giflib
    libxpm
    libjpeg
    libpng
    libtiff
    libwebp
  ];

  outputs = [
    "out"
    "dev"
  ];

  strictDeps = true;

  passthru.updateScript = unstableGitUpdater {
    tagFormat = "release-1.*";
    tagPrefix = "release-";
    branch = "SDL-1.2";
  };

  meta = {
    homepage = "http://www.libsdl.org/projects/SDL_image/";
    description = "SDL image library";
    license = lib.licenses.zlib;
    teams = [ lib.teams.sdl ];
    inherit (SDL.meta) platforms;
  };
})
