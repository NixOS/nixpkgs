{
  lib,
  stdenv,
  fetchFromGitHub,

  # nativeBuildInputs
  cmake,
  wrapGAppsHook3,
  pkg-config,
  ninja,

  # buildInputs
  alsa-lib,
  alsa-plugins,
  freetype,
  libjack2,
  libogg,
  libpulseaudio,
  libsndfile,
  libvorbis,
  portaudio,
  portmidi,
  flac,
  libopusenc,
  libopus,
  mnxdom,
  kdePackages,

  # passthru tests
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "musescore";
  version = "4.7.0";

  src = fetchFromGitHub {
    owner = "musescore";
    repo = "MuseScore";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AEYZWkcjqB2pW+oBow2oMX1HQn4kRaTBBxhyxIbG0a4=";
  };

  cmakeFlags = [
    (lib.cmakeFeature "MUSE_APP_BUILD_MODE" "release")
    # Disable the build and usage of the `/bin/crashpad_handler` utility - it's
    # not useful on NixOS, see:
    # https://github.com/musescore/MuseScore/issues/15571
    (lib.cmakeBool "MUSE_MODULE_DIAGNOSTICS_CRASHPAD_CLIENT" false)
    # Don't build unit tests unless we are going to run them.
    (lib.cmakeBool "MUSE_ENABLE_UNIT_TESTS" finalAttrs.finalPackage.doCheck)
  ]
  # Use our versions of system libraries, see:
  # https://github.com/musescore/MuseScore/issues/11572
  ++ map (l: lib.cmakeBool "MUE_COMPILE_USE_SYSTEM_${l}" true) [
    "FREETYPE"
    "HARFBUZZ"
    "MNXDOM"
    # Implies also OPUS
    "OPUSENC"
    "FLAC"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # https://github.com/musescore/MuseScore/issues/33467
    (lib.cmakeBool "MUE_BUILD_MACOS_INTEGRATION" false)
  ];

  qtWrapperArgs = [
    # MuseScore JACK backend loads libjack at runtime.
    "--prefix ${lib.optionalString stdenv.hostPlatform.isDarwin "DY"}LD_LIBRARY_PATH : ${
      lib.makeLibraryPath [ libjack2 ]
    }"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux) [
    "--set ALSA_PLUGIN_DIR ${alsa-plugins}/lib/alsa-lib"
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    # There are some issues with using the wayland backend, see:
    # https://musescore.org/en/node/321936
    "--set-default QT_QPA_PLATFORM xcb"
  ];

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  dontWrapGApps = true;

  nativeBuildInputs = [
    kdePackages.wrapQtAppsHook
    cmake
    kdePackages.qttools
    pkg-config
    ninja
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    # Since https://github.com/musescore/MuseScore/pull/13847/commits/685ac998
    # GTK3 is needed for file dialogs. Fixes crash with No GSettings schemas error.
    wrapGAppsHook3
  ];

  buildInputs = [
    libjack2
    freetype
    libogg
    libpulseaudio
    libsndfile
    libvorbis
    portaudio
    portmidi
    flac
    libopusenc
    libopus
    mnxdom
    kdePackages.qtbase
    kdePackages.qtdeclarative
    kdePackages.qt5compat
    kdePackages.qtsvg
    kdePackages.qtscxml
    kdePackages.qtnetworkauth
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    kdePackages.qtwayland
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p "$out/Applications"
    mv "$out/mscore.app" "$out/Applications/mscore.app"
    mkdir -p $out/bin
    ln -s $out/Applications/mscore.app/Contents/MacOS/mscore $out/bin/mscore
  '';

  # muse-sounds-manager installs Muse Sounds sampler libMuseSamplerCoreLib.so.
  # It requires that argv0 of the calling process ends with "/mscore" or "/MuseScore-4".
  # We need to ensure this in two cases:
  #
  # 1) when the user invokes MuseScore as "mscore" on the command line or from
  #    the .desktop file, and the normal argv0 is "mscore" (no "/");
  # 2) when MuseScore invokes itself via File -> New, and the normal argv0 is
  #    the target of /proc/self/exe, which in Nixpkgs was "{...}/.mscore-wrapped"
  #
  # In order to achieve (2) we install the final binary as $out/libexec/mscore, and
  # in order to achieve (1) we use makeWrapper without --inherit-argv0.
  #
  # wrapQtAppsHook uses wrapQtApp -> wrapProgram -> makeBinaryWrapper --inherit-argv0
  # so we disable it and explicitly use makeQtWrapper.
  #
  # TODO: check if something like this is also needed for macOS.
  dontWrapQtApps = stdenv.hostPlatform.isLinux;
  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir -p $out/libexec
    mv $out/bin/mscore $out/libexec
    makeQtWrapper $out/libexec/mscore $out/bin/mscore
  '';

  # Don't run bundled upstreams tests, as they require a running X window system.
  doCheck = false;

  passthru.tests = nixosTests.musescore;

  meta = {
    description = "Music notation and composition software";
    homepage = "https://musescore.org/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      vandenoever
      doronbehar
      sarunint
    ];
    mainProgram = "mscore";
    platforms = lib.platforms.unix;
  };
})
