{
  lib,
  fetchFromGitHub,
  cmake,
  ninja,
  clangStdenv,
  pkg-config,
  alsa-lib,
  avahi,
  avahi-compat,
  bluez,
  boost,
  fmt,
  ffmpeg,
  fftw,
  flac,
  git,
  gnutls,
  lame,
  libcoap,
  libjack2,
  libopus,
  libsamplerate,
  libsndfile,
  libvorbis,
  lilv,
  lv2,
  mpg123,
  pipewire,
  portaudio,
  qt6,
  rapidfuzz-cpp,
  re2,
  rubberband,
  snappy,
  SDL2,
  spdlog,
  suil,
  udev,
}:

# TODO: figure out LLVM jit
# assert lib.versionAtLeast llvm.version "15";

clangStdenv.mkDerivation (finalAttrs: {
  pname = "ossia-score";
  version = "3.7.1";

  src = fetchFromGitHub {
    owner = "ossia";
    repo = "score";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+RUspDEAQPL6M0/f4lb/SuTD1wdmwE9+8GXQKUClgdE=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    ninja
    git
    pkg-config
    qt6.qttools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    alsa-lib
    boost
    avahi
    avahi-compat
    bluez
    ffmpeg
    fftw
    flac
    fmt
    gnutls
    lame
    libcoap
    libjack2
    libopus
    libsamplerate
    libsndfile
    libvorbis
    lilv
    lv2
    mpg123
    pipewire
    portaudio
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtserialport
    qt6.qtscxml
    qt6.qtshadertools
    qt6.qtsvg
    qt6.qtwayland
    qt6.qtwebsockets
    rapidfuzz-cpp
    re2
    rubberband
    snappy
    SDL2
    spdlog
    suil
    udev
  ];

  cmakeFlags = [
    "-Wno-dev"

    "-DSCORE_DEPLOYMENT_BUILD=1"
    "-DSCORE_STATIC_PLUGINS=1"
    "-DSCORE_FHS_BUILD=1"
    "-DCMAKE_UNITY_BUILD=1"
    "-DCMAKE_SKIP_RPATH=ON"
    "-DOSSIA_USE_SYSTEM_LIBRARIES=1"
    "-DSCORE_USE_SYSTEM_LIBRARIES=1"

    "-DLilv_INCLUDE_DIR=${lilv.dev}/include/lilv-0"
    "-DSuil_INCLUDE_DIR=${suil}/include/suil-0"
  ];

  # Needed for libraries that get dlopen'd
  env.NIX_LDFLAGS = toString [
    "-lasound"
    "-llilv-0"
    "-lsuil-0"
    "-lsndfile"
    "-lpipewire-0.3"
    "-lfftw3"
    "-lfftw3_threads"
    "-ludev"
  ];

  runtimeDependencies = [
    alsa-lib
    avahi
    avahi-compat
    bluez
    fftw
    lilv
    suil
    pipewire
    udev
  ];

  installPhase = ''
    runHook preInstall

    cmake -DCMAKE_INSTALL_DO_STRIP=1 -DCOMPONENT=OssiaScore -P cmake_install.cmake

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://ossia.io/score/about.html";
    description = "Sequencer for audio-visual artists";
    longDescription = ''
      ossia score is a sequencer for audio-visual artists, designed to enable
      the creation of interactive shows, museum installations, intermedia
      digital artworks, interactive music and more in an intuitive user interface.
    '';
    platforms = platforms.linux;
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      jcelerier
      minijackson
    ];
  };
})
