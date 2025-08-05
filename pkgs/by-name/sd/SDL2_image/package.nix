{
  lib,
  SDL2,
  autoreconfHook,
  fetchurl,
  libjpeg,
  libpng,
  libtiff,
  libwebp,
  pkg-config,
  stdenv,
  zlib,
  # Boolean flags
  enableSTB ? true,
  ## Darwin headless will hang when trying to run the SDL test program
  enableSdltest ? (!stdenv.hostPlatform.isDarwin),
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "SDL2_image";
  version = "2.8.8";

  src = fetchurl {
    url = "https://www.libsdl.org/projects/SDL_image/release/SDL2_image-${finalAttrs.version}.tar.gz";
    hash = "sha256-IhO1b9r/IiDQ44yOQgy+GoPIc3QZDLqMcK8hVgl84wo=";
  };

  nativeBuildInputs = [
    SDL2
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    SDL2
    libtiff
    libwebp
    zlib
  ]
  ++ lib.optionals (!enableSTB) [
    libjpeg
    libpng
  ];

  configureFlags = [
    # Disable dynamically loaded dependencies
    (lib.enableFeature false "jpg-shared")
    (lib.enableFeature false "png-shared")
    (lib.enableFeature false "tif-shared")
    (lib.enableFeature false "webp-shared")
    (lib.enableFeature enableSTB "stb-image")
    (lib.enableFeature enableSdltest "sdltest")
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Don't use native macOS frameworks
    # Caution: do not set this as (!stdenv.hostPlatform.isDarwin) since it would be true
    # outside Darwin - and ImageIO does not exist outside Darwin
    (lib.enableFeature false "imageio")
  ];

  strictDeps = true;

  enableParallelBuilding = true;

  meta = {
    description = "SDL image library";
    homepage = "https://github.com/libsdl-org/SDL_image";
    license = lib.licenses.zlib;
    teams = [ lib.teams.sdl ];
    platforms = lib.platforms.unix;
  };
})
