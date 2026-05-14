{
  lib,
  stdenv,
  fetchFromGitHub,
  replaceVars,
  unstableGitUpdater,
  cmake,
  pkg-config,
  alsa-lib,
  carla,
  fftwFloat,
  fltk,
  fluidsynth,
  glibc_multi,
  lame,
  libgig,
  libjack2,
  libogg,
  libpulseaudio,
  libsForQt5,
  libsamplerate,
  libsoundio,
  libsndfile,
  libvorbis,
  lilv,
  lv2,
  perl5,
  perl5Packages,
  portaudio,
  qt5,
  sndio,
  SDL2,
  suil,
  wineWow64Packages,
  withALSA ? true,
  withPulseAudio ? true,
  withSoundio ? false,
  withPortAudio ? false,
  withSndio ? false,
  withJACK ? true,
  withSDL ? true,
  withOggVorbis ? true,
  withMP3Lame ? true,
  withSoundFont ? true,
  withZyn ? true,
  withSWH ? true,
  withSID ? true,
  withGIG ? true,
  withLV2 ? true,
  withVST ? true,
  withCarla ? true,
  withWine ? false,
}:

let
  winePackages =
    if lib.isDerivation wineWow64Packages then wineWow64Packages else wineWow64Packages.minimal;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "lmms";
  version = "1.2.2-unstable-2026-04-21";

  src = fetchFromGitHub {
    owner = "LMMS";
    repo = "lmms";
    rev = "fc3dfda961a7923326d2b0d5747e5d8fd941af98";
    hash = "sha256-q8w1CgM2QnkCIOUJlv8r+2zMKl+brbNKoAkhDJEhaN0=";
    fetchSubmodules = true;
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    libsForQt5.qt5.qttools
    pkg-config
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    fftwFloat
    libsForQt5.qt5.qtbase
    libsForQt5.qt5.qtsvg
    libsForQt5.qt5.qtx11extras
    libsamplerate
    libsndfile
  ]
  ++ lib.optionals withALSA [
    alsa-lib
  ]
  ++ lib.optionals withPulseAudio [
    libpulseaudio
  ]
  ++ lib.optionals withSoundio [
    libsoundio
  ]
  ++ lib.optionals withPortAudio [
    portaudio
  ]
  ++ lib.optionals withSndio [
    sndio
  ]
  ++ lib.optionals withJACK [
    libjack2
  ]
  ++ lib.optionals withSDL [
    SDL2
  ]
  ++ lib.optionals withOggVorbis [
    libogg
    libvorbis
  ]
  ++ lib.optionals withMP3Lame [
    lame
  ]
  ++ lib.optionals withSoundFont [
    fluidsynth
  ]
  ++ lib.optionals withZyn [
    fltk
  ]
  ++ lib.optionals (withSWH || withSID) [
    perl5
    perl5Packages.ListMoreUtils
    perl5Packages.XMLParser
  ]
  ++ lib.optionals withGIG [
    libgig
  ]
  ++ lib.optionals withLV2 [
    lilv
    lv2
    suil
  ]
  ++ lib.optionals withCarla [
    carla
  ]
  ++ lib.optionals withWine [
    glibc_multi
    winePackages
  ];

  patches = [
    # Use modern CMake imported target for libgig so that its non-standard
    # library path (lib/libgig/) is properly propagated to the install RPATH.
    ./0002-fix-gigplayer-linking.patch
  ]
  ++ lib.optionals withWine [
    (replaceVars ./0001-fix-add-unique-string-to-FindWine-for-replacement-in.patch {
      WINE_LOCATION = winePackages;
    })
  ];

  cmakeFlags = [
    # Fix the build with CMake 4.
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    (lib.cmakeBool "WANT_ALSA" withALSA)
    (lib.cmakeBool "WANT_PULSEAUDIO" withPulseAudio)
    (lib.cmakeBool "WANT_SOUNDIO" withSoundio)
    (lib.cmakeBool "WANT_PORTAUDIO" withPortAudio)
    (lib.cmakeBool "WANT_SNDIO" withSndio)
    (lib.cmakeBool "WANT_JACK" withJACK)
    (lib.cmakeBool "WANT_WEAKJACK" withJACK)
    (lib.cmakeBool "WANT_SDL" withSDL)
    (lib.cmakeBool "WANT_OGGVORBIS" withOggVorbis)
    (lib.cmakeBool "WANT_MP3LAME" withMP3Lame)
    (lib.cmakeBool "WANT_SF2" withSoundFont)
    (lib.cmakeBool "WANT_GIG" withGIG)
    (lib.cmakeBool "WANT_SID" withSID)
    (lib.cmakeBool "WANT_SWH" withSWH)
    (lib.cmakeBool "WANT_LV2" withLV2)
    (lib.cmakeBool "WANT_VST" withVST)
    (lib.cmakeBool "WANT_CARLA" withCarla)
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "DAW similar to FL Studio (music production software)";
    mainProgram = "lmms";
    homepage = "https://lmms.io";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      wizardlink
      jaredmontoya
    ];
  };
})
