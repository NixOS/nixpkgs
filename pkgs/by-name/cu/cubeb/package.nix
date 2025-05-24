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
  alsaSupport ? !stdenv.hostPlatform.isDarwin,
  pulseSupport ? !stdenv.hostPlatform.isDarwin,
  jackSupport ? !stdenv.hostPlatform.isDarwin,
  sndioSupport ? !stdenv.hostPlatform.isDarwin,
  buildSharedLibs ? true,
}:

stdenv.mkDerivation {
  pname = "cubeb";
  version = "0-unstable-2025-04-02";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "cubeb";
    rev = "975a727e5e308a04cfb9ecdf7ddaf1150ea3f733";
    hash = "sha256-3IP++tdiJUwXR6t5mf/MkPd524K/LYESNMkQ8vy10jo=";
  };

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs =
    [ speexdsp ]
    # In the default configuration these inputs are lazy-loaded. If your package builds a vendored cubeb please make
    # sure to include these in the runtime LD path.
    ++ lib.optional alsaSupport alsa-lib
    ++ lib.optional jackSupport jack2
    ++ lib.optional pulseSupport libpulseaudio
    ++ lib.optional sndioSupport sndio;

  patches = [
    # https://github.com/mozilla/cubeb/pull/813
    ./0001-cmake-add-pkg-config-file-generation.patch

    # https://github.com/mozilla/cubeb/pull/814
    ./0001-cmake-don-t-hardcode-include-as-the-includedir.patch
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" buildSharedLibs)
    (lib.cmakeBool "BUILD_TESTS" false) # tests require an audio server
    (lib.cmakeBool "BUNDLE_SPEEX" false)
    (lib.cmakeBool "USE_SANITIZERS" false)

    # Whether to lazily load libraries with dlopen()
    (lib.cmakeBool "LAZY_LOAD_LIBS" false)
  ];

  passthru = {
    updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };
  };

  meta = with lib; {
    description = "Cross platform audio library";
    mainProgram = "cubeb-test";
    homepage = "https://github.com/mozilla/cubeb";
    license = licenses.isc;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [
      zhaofengli
      marcin-serwin
    ];
  };
}
