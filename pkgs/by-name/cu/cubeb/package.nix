{
  lib,
  stdenv,
  fetchFromGitHub,
  unstableGitUpdater,
  cmake,
  pkg-config,
  alsa-lib,
  jack2,
  libpulseaudio,
  sndio,
  speexdsp,
  validatePkgConfig,

  # passthru.tests
  testers,

  alsaSupport ? !stdenv.hostPlatform.isDarwin,
  pulseSupport ? !stdenv.hostPlatform.isDarwin,
  jackSupport ? !stdenv.hostPlatform.isDarwin,
  sndioSupport ? !stdenv.hostPlatform.isDarwin,
  enableShared ? !stdenv.hostPlatform.isStatic,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cubeb";
  version = "0-unstable-2026-06-09";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "cubeb";
    rev = "b18d6992feeb7d4c4a0992257c85d96d761e68d2";
    hash = "sha256-H5ehdZ3PmH8VcBns7h8KsmsAjRVJqS7TSTeUwW/ucTM=";
  };

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    validatePkgConfig
  ];

  buildInputs = [
    speexdsp
  ]
  # In the default configuration these inputs are lazy-loaded. If your package builds a vendored cubeb please make
  # sure to include these in the runtime LD path.
  ++ lib.optional alsaSupport alsa-lib
  ++ lib.optional jackSupport jack2
  ++ lib.optional pulseSupport libpulseaudio
  ++ lib.optional sndioSupport sndio;

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" enableShared)
    (lib.cmakeBool "BUILD_TESTS" false) # tests require an audio server
    (lib.cmakeBool "BUNDLE_SPEEX" false)
    (lib.cmakeBool "USE_SANITIZERS" false)

    # Whether to lazily load libraries with dlopen()
    (lib.cmakeBool "LAZY_LOAD_LIBS" false)
  ];

  passthru = {
    updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "Cross platform audio library";
    mainProgram = "cubeb-test";
    homepage = "https://github.com/mozilla/cubeb";
    license = lib.licenses.isc;
    platforms = with lib.platforms; linux ++ darwin;
    maintainers = with lib.maintainers; [
      zhaofengli
      marcin-serwin
    ];
    pkgConfigModules = [ "libcubeb" ];
  };
})
