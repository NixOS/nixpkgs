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
, qtgraphicaleffects
, flac
, qtquickcontrols
, qtquickcontrols2
, qtscript
, qtsvg
, qtxmlpatterns
, qtnetworkauth
, qtx11extras
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
  version = "4.1.1";

  src = fetchFromGitHub {
    owner = "musescore";
    repo = "MuseScore";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-jXievVIA0tqLdKLy6oPaOHPIbDoFstveEQBri9M0Aoo=";
  };
  patches = [
    # Upstream from some reason wants to install qml files from qtbase in
    # installPhase, this patch removes this behavior. See:
    # https://github.com/musescore/MuseScore/issues/18665
    (fetchpatch {
      url = "https://github.com/doronbehar/MuseScore/commit/f48448a3ede46f5a7ef470940072fbfb6742487c.patch";
      hash = "sha256-UEc7auscnW0KMfWkLKQtm+UstuTNsuFeoNJYIidIlwM=";
    })
    # Upstream removed the option to use system freetype library in v4.1.0,
    # causing the app to crash on systems when the outdated bundled freetype
    # tries to load the Noto Sans font. For more info on the crash itself,
    # see #244409 and https://github.com/musescore/MuseScore/issues/18795.
    # For now, re-add the option ourselves. The fix has been merged upstream,
    # so we can remove this patch with the next version. In the future, we
    # may replace the other bundled thirdparty libs with system libs, see
    # https://github.com/musescore/MuseScore/issues/11572.
    (fetchpatch {
      url = "https://github.com/musescore/MuseScore/commit/9ab6b32b1c3b990cfa7bb172ee8112521dc2269c.patch";
      hash = "sha256-5GA29Z+o3I/uDTTDbkauZ8/xSdCE6yY93phMSY0ea7s=";
    })
  ];

  cmakeFlags = [
    "-DMUSESCORE_BUILD_MODE=release"
    # Disable the build and usage of the `/bin/crashpad_handler` utility - it's
    # not useful on NixOS, see:
    # https://github.com/musescore/MuseScore/issues/15571
    "-DMUE_BUILD_CRASHPAD_CLIENT=OFF"
    # Use our freetype
    "-DMUE_COMPILE_USE_SYSTEM_FREETYPE=ON"
    # From some reason, in $src/build/cmake/SetupBuildEnvironment.cmake,
    # upstream defaults to compiling to x86_64 only, unless this cmake flag is
    # set
    "-DMUE_COMPILE_BUILD_MACOS_APPLE_SILICON=ON"
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

  # HACK `propagatedSandboxProfile` does not appear to actually propagate the
  # sandbox profile from `qtbase`, see:
  # https://github.com/NixOS/nixpkgs/issues/237458
  sandboxProfile = toString qtbase.__propagatedSandboxProfile or null;

  nativeBuildInputs = [
    wrapQtAppsHook
    cmake
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
    qtbase
    qtdeclarative
    qtgraphicaleffects
    qtquickcontrols
    qtquickcontrols2
    qtscript
    qtsvg
    qtxmlpatterns
    qtnetworkauth
    qtx11extras
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
    ln -s $out/Applications/mscore.app/Contents/MacOS/mscore $out/bin/mscore.
  '';

  # Don't run bundled upstreams tests, as they require a running X window system.
  doCheck = false;

  passthru.tests = nixosTests.musescore;

  meta = with lib; {
    description = "Music notation and composition software";
    homepage = "https://musescore.org/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ vandenoever doronbehar ];
    # on aarch64-linux:
    # error: cannot convert '<brace-enclosed initializer list>' to 'float32x4_t' in assignment
    broken = (stdenv.isLinux && stdenv.isAarch64);
    mainProgram = "mscore";
  };
})
