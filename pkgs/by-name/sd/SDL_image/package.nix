{
  lib,
  SDL,
  fetchFromGitHub,
  giflib,
  libXpm,
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
  version = "1.2.12-unstable-2025-02-13";

  src = fetchFromGitHub {
    owner = "libsdl-org";
    repo = "SDL_image";
    rev = "74e8d577216e3c3a969e67b68b2e4769fcbf8fdd";
    hash = "sha256-WSNH7Pw/tL5rgPQtOjxRGp2UlYSJJmXS2YQS+fAkXSc=";
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
    libXpm
    libjpeg
    libpng
    libtiff
    libwebp
  ];

  env = lib.optionalAttrs stdenv.cc.isGNU {
    NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";
  };

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
    maintainers = lib.teams.sdl.members ++ (with lib.maintainers; [ ]);
    inherit (SDL.meta) platforms;
  };
})
