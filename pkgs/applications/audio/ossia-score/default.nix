{ stdenv
, lib
, fetchFromGitHub
, cmake
, ninja
, pkg-config
, qttools
, wrapQtAppsHook
, alsa-lib
, boost182
# , faust
, ffmpeg
, fftw
, flac
, lame
, libjack2
, libopus
, libsndfile
, libvorbis
, lilv
, lv2
, mpg123
, pipewire
, portaudio
, portmidi
, qtbase
, qtdeclarative
, qtscxml
, qtserialport
, qtshadertools
, qtsvg
, qtwayland
, qtwebsockets
, suil
}:

# TODO: figure out LLVM jit
# assert lib.versionAtLeast llvm.version "13";

stdenv.mkDerivation (finalAttrs: {
  pname = "ossia-score";
  version = "3.1.12";

  src = fetchFromGitHub {
    owner = "ossia";
    repo = "score";
    rev = "v${finalAttrs.version}";
    hash = "sha256-SLovwDt+TORJI00sRhizdLhIEm/2U7K3tt0EwBLyx4I=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ninja pkg-config qttools wrapQtAppsHook ];

  # TODO: figure out if we want avahi / bluez / speex / SDL2 (needed for joystick support) by default
  # what about leapmotion?
  buildInputs = [
    alsa-lib
    boost182
    # faust
    ffmpeg
    fftw
    flac
    lame
    libjack2
    libopus
    libsndfile
    libvorbis
    lilv
    lv2
    mpg123
    pipewire
    portaudio
    portmidi
    qtbase
    qtdeclarative
    qtserialport
    qtscxml
    qtshadertools
    qtsvg
    qtwayland
    qtwebsockets
    suil
  ];

  cmakeFlags = [
    "-Wno-dev"

    "-DSCORE_DEPLOYMENT_BUILD=1"
    "-DSCORE_STATIC_PLUGINS=1"
    "-DSCORE_FHS_BUILD=1"
    "-DCMAKE_UNITY_BUILD=1"
    "-DCMAKE_SKIP_RPATH=ON"

    "-DLilv_INCLUDE_DIR=${lilv.dev}/include/lilv-0"
    "-DLilv_LIBRARY=${lilv}/lib/liblilv-0.so"

    "-DSuil_INCLUDE_DIR=${suil}/include/suil-0"
    "-DSuil_LIBRARY=${suil}/lib/libsuil-0.so"
  ];

  # Ossia dlopen's these at runtime, refuses to start without them
  env.NIX_LDFLAGS = toString [
    "-llilv-0"
    "-lsuil-0"
  ];

  installPhase = ''
    runHook preInstall

    cmake -DCMAKE_INSTALL_DO_STRIP=1 -DCOMPONENT=OssiaScore -P cmake_install.cmake

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://ossia.io/score/about.html";
    description = "A sequencer for audio-visual artists, designed to enable the creation of interactive shows, museum installations, intermedia digital artworks, interactive music and more in an intuitive user interface";
    # TODO: this should work for darwin too
    platforms = platforms.linux;
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ minijackson ];
  };
})
