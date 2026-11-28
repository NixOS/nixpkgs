{
  lib,
  SDL2,
  fetchFromGitHub,
  pkg-config,
  stdenv,
  testers,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "SDL2_gfx";
  version = "1.1.0";

  src = fetchFromGitHub {
    tag = "v${finalAttrs.version}";
    repo = "SDL2_gfx";
    owner = "ferzkopp";
    hash = "sha256-17HgBM58y4nah310uXcMLn9df2YUqjAdKWNc2m34gjA=";
  };

  # upstream is silly
  postPatch = ''
    substituteInPlace cmake/SDL2_gfx.pc.in \
      --replace-fail '=''${prefix}/@CMAKE_INSTALL_LIBDIR@' '=@CMAKE_INSTALL_FULL_LIBDIR@' \
      --replace-fail '=''${prefix}/@CMAKE_INSTALL_INCLUDEDIR@' '=@CMAKE_INSTALL_FULL_INCLUDEDIR@'
  '';

  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    SDL2
    pkg-config
  ];

  buildInputs = [
    SDL2
  ];

  outputs = [
    "out"
    "dev"
  ];

  cmakeFlags = [
    (lib.cmakeBool "SDL2GFX_SHARED" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "SDL2GFX_STATIC" stdenv.hostPlatform.isStatic)
    (lib.cmakeBool "SDL2GFX_DEMOS" false)
    (lib.cmakeBool "SDL2GFX_BENCH" false)
    (lib.cmakeBool "SDL2GFX_DOCS" false) # somewhat broken
    (lib.cmakeBool "SDL2GFX_TESTS" false) # needs SDL2::SDL2test
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
  ];

  strictDeps = true;

  enableParallelBuilding = true;

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

      - Graphic Primitives (SDL_gfxPrimitives.h)
      - Rotozoomer (SDL_rotozoom.h)
      - Framerate control (SDL_framerate.h)
      - MMX image filters (SDL_imageFilter.h)
      - Custom Blit functions (SDL_gfxBlitFunc.h)

      The library is backwards compatible to the above mentioned code. Its is
      written in plain C and can be used in C++ code.
    '';
    license = lib.licenses.zlib;
    teams = [ lib.teams.sdl ];
    pkgConfigModules = [ "SDL2_gfx" ];
    inherit (SDL2.meta) platforms;
  };
})
