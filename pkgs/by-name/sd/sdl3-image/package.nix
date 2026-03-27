{
  lib,
  sdl3,
  libavif,
  libtiff,
  libwebp,
  stdenv,
  cmake,
  fetchFromGitHub,
  validatePkgConfig,
  libpng,
  libjpeg,
  libjxl,
  nix-update-script,
  # Boolean flags
  enableTests ? true,
  enableSTB ? true,
  enableImageIO ? stdenv.hostPlatform.isDarwin,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sdl3-image";
  version = "3.4.0";

  outputs = [
    "lib"
    "dev"
    "out"
  ];

  src = fetchFromGitHub {
    owner = "libsdl-org";
    repo = "SDL_image";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-XRPHDcJ49sZa7y8TCWfS2gPOhpGyUnMMXVqvjV9f8E0=";
  };

  strictDeps = true;
  doCheck = true;

  nativeBuildInputs = [
    cmake
    validatePkgConfig
  ];

  buildInputs = [
    sdl3
    libtiff
    libpng
    libwebp
    libjxl
  ]
  ++ (lib.optional (!stdenv.hostPlatform.isDarwin) libavif)
  ++ (lib.optional (!enableSTB) libjpeg);

  cmakeFlags = [
    # fail when a dependency could not be found
    (lib.cmakeBool "SDLIMAGE_STRICT" true)
    # disable shared dependencies as they're opened at runtime using SDL_LoadObject otherwise.
    (lib.cmakeBool "SDLIMAGE_DEPS_SHARED" false)
    # enable stb conditionally
    (lib.cmakeBool "SDLIMAGE_BACKEND_STB" enableSTB)
    # enable imageio backend
    (lib.cmakeBool "SDLIMAGE_BACKEND_IMAGEIO" enableImageIO)
    # enable tests
    (lib.cmakeBool "SDLIMAGE_TESTS" enableTests)
    # enable jxl
    (lib.cmakeBool "SDLIMAGE_JXL" true)
    # disable avif on darwin (see https://github.com/NixOS/nixpkgs/issues/400910)
    (lib.cmakeBool "SDLIMAGE_AVIF" (!stdenv.hostPlatform.isDarwin))
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "release-(3\\..*)"
    ];
  };

  meta = {
    description = "SDL image library";
    homepage = "https://github.com/libsdl-org/SDL_image";
    license = lib.licenses.zlib;
    maintainers = [ lib.maintainers.evythedemon ];
    teams = [ lib.teams.sdl ];
    inherit (sdl3.meta) platforms;
  };
})
