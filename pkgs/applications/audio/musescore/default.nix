{ mkDerivation, lib, fetchFromGitHub, fetchpatch, cmake, pkg-config, ninja
, alsa-lib, freetype, libjack2, lame, libogg, libpulseaudio, libsndfile, libvorbis
, portaudio, portmidi, qtbase, qtdeclarative, qtgraphicaleffects, flac
, qtquickcontrols2, qtscript, qtsvg, qttools
, qtwebengine, qtxmlpatterns, qtnetworkauth, qtx11extras
, nixosTests
}:

mkDerivation rec {
  pname = "musescore";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "musescore";
    repo = "MuseScore";
    rev = "v${version}";
    sha256 = "sha256-3NSHUdTyAC/WOhkB6yBrqtV3LV4Hl1m3poB3ojtJMfs=";
  };
  patches = [
    # See https://github.com/musescore/MuseScore/issues/15571
    (fetchpatch {
      url = "https://github.com/musescore/MuseScore/commit/365be5dfb7296ebee4677cb74b67c1721bc2cf7b.patch";
      hash = "sha256-tJ2M21i3geO9OsjUQKNatSXTkJ5U9qMT4RLNdJnyoKw=";
    })
  ];

  cmakeFlags = [
    "-DMUSESCORE_BUILD_CONFIG=release"
    # Disable the _usage_ of the `/bin/crashpad_handler` utility. See:
    # https://github.com/musescore/MuseScore/pull/15577
    "-DBUILD_CRASHPAD_CLIENT=OFF"
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

  nativeBuildInputs = [ cmake pkg-config ninja ];

  buildInputs = [
    alsa-lib libjack2 freetype lame libogg libpulseaudio libsndfile libvorbis
    portaudio portmidi flac # tesseract
    qtbase qtdeclarative qtgraphicaleffects qtquickcontrols2
    qtscript qtsvg qttools qtwebengine qtxmlpatterns qtnetworkauth qtx11extras
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
