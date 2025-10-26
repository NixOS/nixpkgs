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
  version = "0-unstable-2026-01-23";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "cubeb";
    rev = "484857522c73318c06f18ba0a3e17525fa98c608";
    hash = "sha256-Uq+UINIXc3uuqS7MwbTQ5pL72KmknM33/3CLH21Od/Y=";
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
