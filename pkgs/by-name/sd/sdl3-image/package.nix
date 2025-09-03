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
  nix-update-script,
  # Boolean flags
  enableTests ? true,
  enableSTB ? true,
  enableImageIO ? stdenv.hostPlatform.isDarwin,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sdl3-image";
  version = "3.2.4";

  outputs = [
    "lib"
    "dev"
    "out"
  ];

  src = fetchFromGitHub {
    owner = "libsdl-org";
    repo = "SDL_image";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-/orQ+YfH0CV8DOqXFMF9fOT4YaVpC1t55xM3j520Png=";
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
    libwebp
    libavif
  ]
  ++ (lib.optionals (!enableSTB) [
    libpng
    libjpeg
  ]);

  cmakeFlags = [
    # fail when a dependency could not be found
    (lib.cmakeBool "SDLIMAGE_STRICT" true)
    # disable shared dependencies as they're opened at runtime using SDL_LoadObject otherwise.
    (lib.cmakeBool "SDLIMAGE_DEPS_SHARED" false)
    # disable stbi
    (lib.cmakeBool "SDLIMAGE_BACKEND_STB" enableSTB)
    # enable imageio backend
    (lib.cmakeBool "SDLIMAGE_BACKEND_IMAGEIO" enableImageIO)
    # enable tests
    (lib.cmakeBool "SDLIMAGE_TESTS" enableTests)
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
