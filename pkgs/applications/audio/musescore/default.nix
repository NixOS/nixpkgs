{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, cmake
, wrapQtAppsHook
, pkg-config
, ninja
, alsa-lib
, freetype
, libjack2
, lame
, libogg
, libpulseaudio
, libsndfile
, libvorbis
, portaudio
, portmidi
, qtbase
, qtdeclarative
, qtgraphicaleffects
, flac
, qtquickcontrols2
, qtscript
, qtsvg
, qttools
, qtwebengine
, qtxmlpatterns
, qtnetworkauth
, qtx11extras
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "musescore";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "musescore";
    repo = "MuseScore";
    rev = "v${version}";
    sha256 = "sha256-CqW1f0VsF2lW79L3FY2ev+6FoHLbYOJ9LWHeBlWegeU=";
  };

  cmakeFlags = [
    "-DMUSESCORE_BUILD_MODE=release"
    # Disable the build and usage of the `/bin/crashpad_handler` utility - it's
    # not useful on NixOS, see:
    # https://github.com/musescore/MuseScore/issues/15571
    "-DMUE_BUILD_CRASHPAD_CLIENT=OFF"
    # Use our freetype
    "-DUSE_SYSTEM_FREETYPE=ON"
  ];

  qtWrapperArgs = [
    # MuseScore JACK backend loads libjack at runtime.
    "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libjack2 ]}"
    # There are some issues with using the wayland backend, see:
    # https://musescore.org/en/node/321936
    "--set-default QT_QPA_PLATFORM xcb"
  ];

  nativeBuildInputs = [
    wrapQtAppsHook
    cmake
    pkg-config
    ninja
  ];

  buildInputs = [
    alsa-lib
    libjack2
    freetype
    lame
    libogg
    libpulseaudio
    libsndfile
    libvorbis
    portaudio
    portmidi
    flac
    qtbase
    qtdeclarative
    qtgraphicaleffects
    qtquickcontrols2
    qtscript
    qtsvg
    qttools
    qtwebengine
    qtxmlpatterns
    qtnetworkauth
    qtx11extras
  ];

  passthru.tests = nixosTests.musescore;

  meta = with lib; {
    description = "Music notation and composition software";
    homepage = "https://musescore.org/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ vandenoever turion doronbehar ];
    # Darwin requires CoreMIDI from SDK 11.3, we use the upstream built .dmg
    # file in ./darwin.nix in the meantime.
    platforms = platforms.linux;
    mainProgram = "mscore";
  };
}
