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
  lazyLoad ? !stdenv.hostPlatform.isDarwin,
  alsaSupport ? !stdenv.hostPlatform.isDarwin,
  pulseSupport ? !stdenv.hostPlatform.isDarwin,
  jackSupport ? !stdenv.hostPlatform.isDarwin,
  sndioSupport ? !stdenv.hostPlatform.isDarwin,
  buildSharedLibs ? true,
}:

assert lib.assertMsg (
  stdenv.hostPlatform.isDarwin -> !lazyLoad
) "cubeb: lazyLoad is inert on Darwin";

let
  backendLibs =
    lib.optional alsaSupport alsa-lib
    ++ lib.optional jackSupport jack2
    ++ lib.optional pulseSupport libpulseaudio
    ++ lib.optional sndioSupport sndio;

in
stdenv.mkDerivation {
  pname = "cubeb";
  version = "0-unstable-2025-04-02";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "cubeb";
    rev = "975a727e5e308a04cfb9ecdf7ddaf1150ea3f733";
    hash = "sha256-3IP++tdiJUwXR6t5mf/MkPd524K/LYESNMkQ8vy10jo=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [ speexdsp ] ++ lib.optionals (!stdenv.hostPlatform.isDarwin) backendLibs;

  patches = [
    # https://github.com/mozilla/cubeb/pull/813
    ./0001-cmake-add-pkg-config-file-generation.patch
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" buildSharedLibs)
    "-DBUILD_TESTS=OFF" # tests require an audio server
    "-DBUNDLE_SPEEX=OFF"
    "-DUSE_SANITIZERS=OFF"

    # Whether to lazily load libraries with dlopen()
    "-DLAZY_LOAD_LIBS=${if lazyLoad then "ON" else "OFF"}"
  ];

  passthru = {
    # For downstream users when lazyLoad is true
    backendLibs = lib.optionals lazyLoad backendLibs;
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
