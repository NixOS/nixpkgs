{
  lib,
  SDL2,
  darwin,
  fetchurl,
  pkg-config,
  stdenv,
  testers,
  # Boolean flags
  enableMmx ? stdenv.hostPlatform.isx86,
  enableSdltest ? (!stdenv.hostPlatform.isDarwin),
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "SDL2_gfx";
  version = "1.0.4";

  src = fetchurl {
    url = "http://www.ferzkopp.net/Software/SDL2_gfx/SDL2_gfx-${finalAttrs.version}.tar.gz";
    hash = "sha256-Y+DgGt3tyd8vhbk6JI8G6KBK/6AUqDXC6jS/405XYmI=";
  };

  nativeBuildInputs = [
    SDL2
    pkg-config
  ];

  buildInputs =
    [
      SDL2
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.libobjc
    ];

  outputs = [
    "out"
    "dev"
  ];

  configureFlags = [
    (lib.enableFeature enableMmx "mmx")
    (lib.enableFeature enableSdltest "sdltest")
  ];

  strictDeps = true;

  passthru = {
    tests.pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
    };
  };

  meta = {
    homepage = "http://www.ferzkopp.net/wordpress/2016/01/02/sdl_gfx-sdl2_gfx/";
    description = "SDL graphics drawing primitives and support functions";
    longDescription = ''
      The SDL_gfx library evolved out of the SDL_gfxPrimitives code which
      provided basic drawing routines such as lines, circles or polygons and
      SDL_rotozoom which implemented a interpolating rotozoomer for SDL
      surfaces.

      The current components of the SDL_gfx library are:

      - Graphic Primitives (SDL_gfxPrimitves.h)
      - Rotozoomer (SDL_rotozoom.h)
      - Framerate control (SDL_framerate.h)
      - MMX image filters (SDL_imageFilter.h)
      - Custom Blit functions (SDL_gfxBlitFunc.h)

      The library is backwards compatible to the above mentioned code. Its is
      written in plain C and can be used in C++ code.
    '';
    license = lib.licenses.zlib;
    maintainers = lib.teams.sdl.members ++ (with lib.maintainers; [ ]);
    pkgConfigModules = [ "SDL2_gfx" ];
    inherit (SDL2.meta) platforms;
  };
})
