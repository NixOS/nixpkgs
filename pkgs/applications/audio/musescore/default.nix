{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  wrapGAppsHook3,
  wrapQtAppsHook,
  pkg-config,
  ninja,
  alsa-lib,
  alsa-plugins,
  freetype,
  libjack2,
  lame,
  libogg,
  libpulseaudio,
  libsndfile,
  libvorbis,
  portaudio,
  portmidi,
  qtbase,
  qtdeclarative,
  flac,
  libopusenc,
  libopus,
  tinyxml-2,
  qt5compat,
  qtwayland,
  qtsvg,
  qtscxml,
  qtnetworkauth,
  qttools,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "musescore";
  version = "4.6.2";

  src = fetchFromGitHub {
    owner = "musescore";
    repo = "MuseScore";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-3VpptHR9dt8lJeFhFygnPiP0XRf4R29SASC8AicLU5E=";
  };

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
    # Don't build unit tests unless we are going to run them.
    (lib.cmakeBool "MUSE_ENABLE_UNIT_TESTS" finalAttrs.finalPackage.doCheck)
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
    wrapQtAppsHook
    cmake
    qttools
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
    lame
    libogg
    libpulseaudio
    libsndfile
    libvorbis
    portaudio
    portmidi
    flac
    libopusenc
    libopus
    tinyxml-2
    qtbase
    qtdeclarative
    qt5compat
    qtsvg
    qtscxml
    qtnetworkauth
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    qtwayland
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

  meta = with lib; {
    description = "Music notation and composition software";
    homepage = "https://musescore.org/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      vandenoever
      doronbehar
      orivej
    ];
    mainProgram = "mscore";
    platforms = platforms.unix;
  };
})
