{
  lib,
  alsa-lib,
  avahi,
  boost,
  cmake,
  fetchFromGitHub,
  flac,
  libjack2,
  libogg,
  libopus,
  libpulseaudio,
  libsndfile,
  libvorbis,
  nixosTests,
  pipewire,
  pkg-config,
  poco,
  protobuf,
  python3,
  qt5,
  rnnoise,
  speechd,
  speex,
  stdenv,
  jackSupport ? false,
  pipewireSupport ? true,
  pulseSupport ? true,
  speechdSupport ? false,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "mumble";
  version = "1.5.634";

  src = fetchFromGitHub {
    owner = "mumble-voip";
    repo = "mumble";
    rev = "v${finalAttrs.version}";
    hash = "sha256-d9XmXHq264rTT80zphYcKLxS+AyUhjb19D3DuBJvMI4=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
    qt5.wrapQtAppsHook
    qt5.qttools
  ];

  buildInputs =
    [
      avahi
      boost
      flac
      libogg
      libopus
      libsndfile
      libvorbis
      poco
      protobuf
      qt5.qtsvg
      rnnoise
      speex
    ]
    ++ lib.optional (!jackSupport) alsa-lib
    ++ lib.optional jackSupport libjack2
    ++ lib.optional speechdSupport speechd
    ++ lib.optional pulseSupport libpulseaudio
    ++ lib.optional pipewireSupport pipewire;

  env.NIX_CFLAGS_COMPILE = lib.optionalString speechdSupport "-I${speechd}/include/speech-dispatcher";

  cmakeFlags =
    [
      "-D g15=OFF"
      "-D CMAKE_CXX_STANDARD=17" # protobuf >22 requires C++ 17
      "-D server=OFF"
      "-D bundled-celt=ON"
      "-D bundled-opus=OFF"
      "-D bundled-speex=OFF"
      "-D bundle-qt-translations=OFF"
      "-D update=OFF"
      "-D overlay-xcompile=OFF"
      "-D oss=OFF"
      "-D warnings-as-errors=OFF" # conversion error workaround
    ]
    ++ lib.optional (!speechdSupport) "-D speechd=OFF"
    ++ lib.optional (!pulseSupport) "-D pulseaudio=OFF"
    ++ lib.optional (!pipewireSupport) "-D pipewire=OFF"
    ++ lib.optional jackSupport "-D alsa=OFF -D jackaudio=ON";

  preConfigure = ''
    patchShebangs scripts
  '';

  postFixup = ''
    wrapProgram $out/bin/mumble \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath (
          lib.optional pulseSupport libpulseaudio ++ lib.optional pipewireSupport pipewire
        )
      }"
  '';

  passthru.tests.connectivity = nixosTests.mumble;

  meta = {
    description = "Low-latency, high quality voice chat software";
    homepage = "https://mumble.info";
    license = lib.licenses.bsd3;
    mainProgram = "mumble";
    maintainers = with lib.maintainers; [
      felixsinger
      lilacious
    ];
    platforms = lib.platforms.linux;
  };
})
