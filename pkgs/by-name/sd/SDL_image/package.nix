{
  lib,
  SDL,
  fetchpatch,
  fetchurl,
  giflib,
  libXpm,
  libjpeg,
  libpng,
  libtiff,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "SDL_image";
  version = "1.2.12";

  src = fetchurl {
    url = "https://www.libsdl.org/projects/SDL_image/release/SDL_image-${finalAttrs.version}.tar.gz";
    hash = "sha256-C5ByKYRWEATehIR3RNVmgJ27na9zKp5QO5GhtahOVpk=";
  };

  patches = [
    # Fixed security vulnerability in XCF image loader
    (fetchpatch {
      name = "CVE-2017-2887";
      url = "https://github.com/libsdl-org/SDL_image/commit/e7723676825cd2b2ffef3316ec1879d7726618f2.patch";
      includes = [ "IMG_xcf.c" ];
      hash = "sha256-Z0nyEtE1LNGsGsN9SFG8ZyPDdunmvg81tUnEkrJQk5w=";
    })
  ];

  configureFlags = [
    # Disable dynamic loading or else dlopen will fail because of no proper
    # rpath
    (lib.enableFeature false "jpg-shared")
    (lib.enableFeature false "png-shared")
    (lib.enableFeature false "tif-shared")
    (lib.enableFeature (!stdenv.isDarwin) "sdltest")
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
  ];

  outputs = [ "out" "dev" ];

  strictDeps = true;

  meta = {
    homepage = "http://www.libsdl.org/projects/SDL_image/";
    description = "SDL image library";
    license = lib.licenses.zlib;
    maintainers = lib.teams.sdl.members
                  ++ (with lib.maintainers; [ ]);
    inherit (SDL.meta) platforms;
  };
})
