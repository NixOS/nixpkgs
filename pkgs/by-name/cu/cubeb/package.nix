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
  version = "0-unstable-2025-07-10";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "cubeb";
    rev = "fa021607121360af7c171d881dc5bc8af7bb56eb";
    hash = "sha256-6PUHUPybe3g5nexunAHsHLThFdvpnv+avks+C0oYih0=";
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
