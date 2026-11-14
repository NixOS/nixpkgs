{
  stdenv,
  lib,
  fetchFromGitHub,
  testers,
  cmake,
  doxygen,
  ffmpeg,
  libass,
  SDL2,
  buildShared ? !stdenv.hostPlatform.isStatic,
  buildStatic ? stdenv.hostPlatform.isStatic,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sdl-kitchensink";
  version = "1.0.13";

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  src = fetchFromGitHub {
    owner = "katajakasa";
    repo = "SDL_kitchensink";
    tag = finalAttrs.version;
    hash = "sha256-jcl8CmYLIldRMZBrygDf8MxSPgLU9diu6rAtwEqXM20=";
  };

  postPatch = ''
    substituteInPlace Doxyfile \
      --replace-fail \
        'OUTPUT_DIRECTORY       = docs/' \
        "OUTPUT_DIRECTORY       = $doc/share/doc/SDL_kitchensink"
  '';

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
    doxygen
  ];

  buildInputs = [
    ffmpeg
    libass
    SDL2
  ];

  cmakeFlags = [
    (lib.strings.cmakeBool "BUILD_SHARED" buildShared)
    (lib.strings.cmakeBool "BUILD_STATIC" buildStatic)
    (lib.strings.cmakeBool "BUILD_EXAMPLES" false)
    (lib.strings.cmakeBool "USE_DYNAMIC_LIBASS" false) # actually link against it please
  ];

  postInstall = ''
    mkdir -p $doc/share/doc/SDL_kitchensink
    make docs
  '';

  passthru.tests.pkg-config = testers.hasPkgConfigModules {
    package = finalAttrs.finalPackage;
    versionCheck = true;
  };

  meta = {
    description = "FFmpeg and SDL2 based library for audio and video playback";
    homepage = "https://github.com/katajakasa/SDL_kitchensink";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.OPNA2608 ];
    pkgConfigModules = [
      "SDL_kitchensink"
    ];
    platforms = lib.platforms.all;
  };
})
