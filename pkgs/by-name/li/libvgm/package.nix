{
  stdenv,
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  testers,
  cmake,
  libiconv,
  zlib,
  enableShared ? (!stdenv.hostPlatform.isStatic),

  enableAudio ? true,
  withWaveWrite ? true,
  withWinMM ? stdenv.hostPlatform.isWindows,
  withDirectSound ? stdenv.hostPlatform.isWindows,
  withXAudio2 ? stdenv.hostPlatform.isWindows,
  withWASAPI ? stdenv.hostPlatform.isWindows,
  withOSS ? stdenv.hostPlatform.isFreeBSD,
  withSADA ? stdenv.hostPlatform.isSunOS,
  withALSA ? stdenv.hostPlatform.isLinux,
  alsa-lib,
  withPulseAudio ? stdenv.hostPlatform.isLinux,
  libpulseaudio,
  withCoreAudio ? stdenv.hostPlatform.isDarwin,
  withLibao ? true,
  libao,

  enableEmulation ? true,
  withAllEmulators ? true,
  emulators ? [ ],

  enableLibplayer ? true,

  enableTools ? false,
}:

assert enableTools -> enableAudio && enableEmulation && enableLibplayer;

stdenv.mkDerivation (finalAttrs: {
  pname = "libvgm";
  version = "0-unstable-2025-08-31";

  src = fetchFromGitHub {
    owner = "ValleyBell";
    repo = "libvgm";
    rev = "e9f2b023e8918b56be0d2e634b3f5aab2a589ffe";
    hash = "sha256-jnjIWB+1IndV7XljG4lUJ93zP9Emlxlx+EWH4xdtLGE=";
  };

  outputs = [
    "out"
    "dev"
  ]
  ++ lib.optionals enableTools [ "bin" ];

  nativeBuildInputs = [ cmake ];

  propagatedBuildInputs = [
    libiconv
    zlib
  ]
  ++ lib.optionals withALSA [ alsa-lib ]
  ++ lib.optionals withPulseAudio [ libpulseaudio ]
  ++ lib.optionals withLibao [ libao ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_LIBAUDIO" enableAudio)
    (lib.cmakeBool "BUILD_LIBEMU" enableEmulation)
    (lib.cmakeBool "BUILD_LIBPLAYER" enableLibplayer)
    (lib.cmakeBool "BUILD_TESTS" enableTools)
    (lib.cmakeBool "BUILD_PLAYER" enableTools)
    (lib.cmakeBool "BUILD_VGM2WAV" enableTools)
    (lib.cmakeFeature "LIBRARY_TYPE" (if enableShared then "SHARED" else "STATIC"))
    (lib.cmakeBool "USE_SANITIZERS" true)
  ]
  ++ lib.optionals enableAudio [
    (lib.cmakeBool "AUDIODRV_WAVEWRITE" withWaveWrite)
    (lib.cmakeBool "AUDIODRV_WINMM" withWinMM)
    (lib.cmakeBool "AUDIODRV_DSOUND" withDirectSound)
    (lib.cmakeBool "AUDIODRV_XAUDIO2" withXAudio2)
    (lib.cmakeBool "AUDIODRV_WASAPI" withWASAPI)
    (lib.cmakeBool "AUDIODRV_OSS" withOSS)
    (lib.cmakeBool "AUDIODRV_SADA" withSADA)
    (lib.cmakeBool "AUDIODRV_ALSA" withALSA)
    (lib.cmakeBool "AUDIODRV_PULSE" withPulseAudio)
    (lib.cmakeBool "AUDIODRV_APPLE" withCoreAudio)
    (lib.cmakeBool "AUDIODRV_LIBAO" withLibao)
  ]
  ++ lib.optionals enableEmulation (
    [ (lib.cmakeBool "SNDEMU__ALL" withAllEmulators) ]
    ++ lib.optionals (!withAllEmulators) (
      lib.lists.forEach emulators (x: (lib.cmakeBool "SNDEMU_${x}" true))
    )
  )
  ++ lib.optionals enableTools [
    (lib.cmakeBool "UTIL_CHARCNV_ICONV" true)
    (lib.cmakeBool "UTIL_CHARCNV_WINAPI" stdenv.hostPlatform.isWindows)
  ];

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = unstableGitUpdater { };
  };

  meta = {
    description = "More modular rewrite of most components from VGMPlay";
    homepage = "https://github.com/ValleyBell/libvgm";
    license =
      if
        (enableEmulation && (withAllEmulators || (lib.lists.any (core: core == "WSWAN_ALL") emulators)))
      then
        lib.licenses.unfree # https://github.com/ValleyBell/libvgm/issues/43
      else
        lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ OPNA2608 ];
    platforms = lib.platforms.all;
    pkgConfigModules = [
      "vgm-utils"
    ]
    ++ lib.optionals enableAudio [ "vgm-audio" ]
    ++ lib.optionals enableEmulation [ "vgm-emu" ]
    ++ lib.optionals enableLibplayer [ "vgm-player" ];
  };
})
