{
  lib,
  sdl3,
  darwin,
  libavif,
  libtiff,
  libwebp,
  stdenv,
  cmake,
  fetchFromGitHub,
  validatePkgConfig,
  # Boolean flags
  enableTests ? true,
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
  ] ++ (lib.optional stdenv.hostPlatform.isDarwin darwin.apple_sdk.frameworks.Foundation);

  cmakeFlags = [
    # fail when a dependency could not be found
    (lib.cmakeBool "SDLIMAGE_STRICT" true)
    # disable shared dependencies as they're opened at runtime using SDL_LoadObject otherwise.
    (lib.cmakeBool "SDLIMAGE_DEPS_SHARED" false)
    # enable imageio backend
    (lib.cmakeBool "SDLIMAGE_BACKEND_IMAGEIO" enableImageIO)
    # enable tests
    (lib.cmakeBool "SDLIMAGE_TESTS" enableTests)
  ];

  meta = {
    description = "SDL image library";
    homepage = "https://github.com/libsdl-org/SDL_image";
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [ evythedemon ];
    inherit (sdl3.meta) platforms;
  };
})
