{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, cmake
, wrapQtAppsHook
, pkg-config
, ninja
, alsa-lib
, alsa-plugins
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
, flac
, libopusenc
, libopus
, tinyxml-2
, qt5compat
, qtwayland
, qtsvg
, qtscxml
, qtnetworkauth
, qttools
, nixosTests
, darwin
}:

let
  stdenv' = if stdenv.isDarwin then darwin.apple_sdk_11_0.stdenv else stdenv;
  # portaudio propagates Darwin frameworks. Rebuild it using the 11.0 stdenv
  # from Qt and the 11.0 SDK frameworks.
  portaudio' = if stdenv.isDarwin then portaudio.override {
    stdenv = stdenv';
    inherit (darwin.apple_sdk_11_0.frameworks)
      AudioUnit
      AudioToolbox
      CoreAudio
      CoreServices
      Carbon
    ;
  } else portaudio;
in stdenv'.mkDerivation (finalAttrs: {
  pname = "musescore";
  version = "4.4.0";

  src = fetchFromGitHub {
    owner = "musescore";
    repo = "MuseScore";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-oDbOaLFmSpZ7D8E7LBxUwFwiaPcucIUj3eEp6sXR5o8=";
  };
  patches = [
    # https://github.com/musescore/MuseScore/pull/24247
    (fetchpatch {
      name = "skip-downloading-harfbuzz.patch";
      url = "https://github.com/musescore/MuseScore/commit/686ea243d58b43eb3dff7ebdabb2e09de4d212e4.patch";
      hash = "sha256-fsb1hKFKXwBdMPh+Ek0UT3XtI8qg3ieWUQW1/XDvhmg=";
    })
    # https://github.com/musescore/MuseScore/pull/24261
    (fetchpatch {
      name = "allow-using-system-harfbuzz.patch";
      url = "https://github.com/musescore/MuseScore/commit/696279e362afe72db5e92f8a47aa64b3a0e86a86.patch";
      hash = "sha256-z1W2SmzUUlVL7mRR2frzUZjMEnwqkVfRVz4TufR1tDU=";
    })
    # https://github.com/musescore/MuseScore/pull/24326
    (fetchpatch {
      name = "fix-menubar-with-qt6.5+.patch";
      url = "https://github.com/musescore/MuseScore/pull/24326/commits/b274f13311ad0b2bce339634a006ba22fbd3379e.patch";
      hash = "sha256-ZGmjRa01CBEIxJdJYQMhdg4A9yjWdlgn0pCPmENBTq0=";
    })
  ];

  cmakeFlags = [
    "-DMUSE_APP_BUILD_MODE=release"
    # Disable the build and usage of the `/bin/crashpad_handler` utility - it's
    # not useful on NixOS, see:
    # https://github.com/musescore/MuseScore/issues/15571
    "-DMUSE_MODULE_DIAGNOSTICS_CRASHPAD_CLIENT=OFF"
    # Use our versions of system libraries
    "-DMUE_COMPILE_USE_SYSTEM_FREETYPE=ON"
    "-DMUE_COMPILE_USE_SYSTEM_HARFBUZZ=ON"
    "-DMUE_COMPILE_USE_SYSTEM_TINYXML=ON"
    # Implies also -DMUE_COMPILE_USE_SYSTEM_OPUS=ON
    "-DMUE_COMPILE_USE_SYSTEM_OPUSENC=ON"
    "-DMUE_COMPILE_USE_SYSTEM_FLAC=ON"
    # Don't bundle qt qml files, relevant really only for darwin, but we set
    # this for all platforms anyway.
    "-DMUE_COMPILE_INSTALL_QTQML_FILES=OFF"
  ];

  qtWrapperArgs = [
    # MuseScore JACK backend loads libjack at runtime.
    "--prefix ${lib.optionalString stdenv.isDarwin "DY"}LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libjack2 ]}"
  ] ++ lib.optionals (stdenv.isLinux) [
    "--set ALSA_PLUGIN_DIR ${alsa-plugins}/lib/alsa-lib"
  ] ++ lib.optionals (!stdenv.isDarwin) [
    # There are some issues with using the wayland backend, see:
    # https://musescore.org/en/node/321936
    "--set-default QT_QPA_PLATFORM xcb"
  ];

  nativeBuildInputs = [
    wrapQtAppsHook
    cmake
    qttools
    pkg-config
    ninja
  ];

  buildInputs = [
    libjack2
    freetype
    lame
    libogg
    libpulseaudio
    libsndfile
    libvorbis
    portaudio'
    portmidi
    flac
    libopusenc
    libopus
    tinyxml-2
    qtbase
    qtdeclarative
    qt5compat
    qtwayland
    qtsvg
    qtscxml
    qtnetworkauth
  ] ++ lib.optionals stdenv.isLinux [
    alsa-lib
  ];

  postInstall = ''
    # Remove unneeded bundled libraries and headers
    rm -r $out/{include,lib}
  '' + lib.optionalString stdenv.isDarwin ''
    mkdir -p "$out/Applications"
    mv "$out/mscore.app" "$out/Applications/mscore.app"
    mkdir -p $out/bin
    ln -s $out/Applications/mscore.app/Contents/MacOS/mscore $out/bin/mscore
  '';

  # Don't run bundled upstreams tests, as they require a running X window system.
  doCheck = false;

  passthru.tests = nixosTests.musescore;

  meta = with lib; {
    description = "Music notation and composition software";
    homepage = "https://musescore.org/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ vandenoever doronbehar ];
    mainProgram = "mscore";
    platforms = platforms.unix;
  };
})
