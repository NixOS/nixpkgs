{
  lib,
  stdenv,
  fetchFromGitHub,
  replaceVars,
  nix-update-script,
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
  libsamplerate,
  libsoundio,
  libsndfile,
  libvorbis,
  libxinerama,
  libxcursor,
  libxft,
  lilv,
  lv2,
  perl,
  portaudio,
  qt5,
  sndio,
  SDL2,
  serd,
  sord,
  sratom,
  suil,
  wineWow64Packages,
  zix,
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
  version = "1.3.0-alpha.2";

  src = fetchFromGitHub {
    owner = "LMMS";
    repo = "lmms";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oCZGvyXtW4gA9MZ10eDeATri8rDP98ZFOBVIVj4kD/Y=";
    fetchSubmodules = true;
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    qt5.qttools
    pkg-config
    qt5.wrapQtAppsHook
  ]
  ++ lib.optionals withZyn [
    fltk
  ]
  ++ lib.optionals (withSWH || withSID) [
    (perl.withPackages (ps: [
      ps.ListMoreUtils
      ps.XMLParser
    ]))
  ];

  buildInputs = [
    fftwFloat
    qt5.qtbase
    qt5.qtsvg
    qt5.qtwayland
    qt5.qtx11extras
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
  ++ lib.optionals withGIG [
    libgig
  ]
  ++ lib.optionals withLV2 [
    lilv
    lv2
    # LMMS's FindLilv.cmake discovers these libraries individually.
    serd
    sord
    sratom
    suil
    zix
  ]
  ++ lib.optionals withCarla [
    carla
  ]
  ++ lib.optionals withWine [
    glibc_multi
    winePackages
  ]
  ++ lib.optionals withZyn [
    libxinerama
    libxcursor
    libxft
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

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=unstable" ];
  };

  meta = {
    description = "DAW similar to FL Studio (music production software)";
    mainProgram = "lmms";
    homepage = "https://lmms.io";
    changelog = "https://github.com/LMMS/lmms/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      wizardlink
      jaredmontoya
    ];
  };
})
