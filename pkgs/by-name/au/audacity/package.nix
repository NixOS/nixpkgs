{
  lib,
  stdenv,
  fetchurl,

  # nativeBuildInputs
  cmake,
  git,
  linuxHeaders,
  ninja,
  pkg-config,
  python3,
  qt6,
  wrapGAppsHook3,

  # buildInputs
  alsa-lib,
  expat,
  ffmpeg,
  flac,
  freetype,
  harfbuzz,
  lame,
  libjack2,
  libogg,
  libopus,
  libsndfile,
  libvorbis,
  mpg123,
  opusfile,
  portaudio,
  pugixml,
  utf8cpp,
  wavpack,
  wxwidgets_3_2,
  zlib,
}:
let
  wxwidgets = wxwidgets_3_2.override { withWebKit = false; };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "audacity";
  version = "4.0.0";

  src = fetchurl {
    url = "https://github.com/audacity/audacity/releases/download/Audacity-${finalAttrs.version}/audacity-sources-${finalAttrs.version}.tar.xz";
    hash = "sha256-spB2+Z+l0vUi0AHbRyqJbbgfnv/v0VlIyUBXF1OFgFg=";
  };

  patches = [
    # https://github.com/musescore/muse_deps/pull/47
    ./muse-deps-wxwidgets-frameworks.patch
    # https://github.com/audacity/audacity/pull/12021
    ./audacity-deployment-target.patch
    # https://github.com/musescore/muse_framework/pull/278
    ./muse-framework-deployment-target.patch
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # https://github.com/audacity/audacity/pull/12056
    ./macdeployqt-extra-options.patch
  ];

  postPatch = lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace au3/libraries/au3-files/FileNames.cpp \
      --replace-fail /usr/include/linux/magic.h ${linuxHeaders}/include/linux/magic.h
  '';

  nativeBuildInputs = [
    cmake
    git
    ninja
    pkg-config
    python3
    qt6.qttools
    qt6.wrapQtAppsHook
    wxwidgets
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    linuxHeaders
    wrapGAppsHook3
  ];

  buildInputs = [
    expat
    ffmpeg
    flac
    freetype
    harfbuzz
    lame
    libjack2
    libogg
    libopus
    libsndfile
    libvorbis
    mpg123
    opusfile
    portaudio
    pugixml
    qt6.qt5compat
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtnetworkauth
    qt6.qtshadertools
    qt6.qtsvg
    utf8cpp
    wavpack
    wxwidgets
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    qt6.qtwayland
  ];

  cmakeFlags = [
    (lib.cmakeFeature "AU4_BUILD_MODE" "release")
    (lib.cmakeFeature "EXTDEPS_OVERRIDE_ALL" "SYSTEM")
    (lib.cmakeBool "MUSE_COMPILE_USE_CCACHE" false)
    (lib.cmakeBool "MUSE_ENABLE_UNIT_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "MUSE_MODULE_DIAGNOSTICS_CRASHPAD_CLIENT" false)
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    (lib.cmakeFeature "CMAKE_OSX_ARCHITECTURES" stdenv.hostPlatform.darwinArch)
    (lib.cmakeFeature "CMAKE_OSX_DEPLOYMENT_TARGET" stdenv.hostPlatform.darwinMinVersion)
    # Nix performs stripping after deployment.
    (lib.cmakeFeature "AU4_MACDEPLOYQT_EXTRA_OPTIONS" "-no-strip")
  ];

  preConfigure = ''
    cmakeFlagsArray+=("-DEXTDEPS_CACHE=$PWD/offline-deps")
  '';

  preInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    export NIX_QMLIMPORTSCANNER=${lib.getBin qt6.qtdeclarative}/libexec/qmlimportscanner
    export QML2_IMPORT_PATH=
    for input in ${lib.escapeShellArgs finalAttrs.buildInputs}; do
      addToSearchPath QML2_IMPORT_PATH "$input/${qt6.qtbase.qtQmlPrefix}"
    done
  '';

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p "$out/Applications"
    mv "$out/audacity.app" "$out/Applications/"
  '';

  qtWrapperArgs = [
    "--prefix"
    "${lib.optionalString stdenv.hostPlatform.isDarwin "DY"}LD_LIBRARY_PATH"
    ":"
    (lib.makeLibraryPath [
      ffmpeg
      libjack2
    ])
  ];

  preFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Use bundled Qt plugins, not a second Qt installation from the store.
    wrapProgram "$out/Applications/audacity.app/Contents/MacOS/audacity" \
      ${lib.escapeShellArgs finalAttrs.qtWrapperArgs} \
      --unset QT_PLUGIN_PATH \
      --unset NIXPKGS_QT6_QML_IMPORT_PATH \
      --unset QML2_IMPORT_PATH \
      --unset QML_IMPORT_PATH
    mkdir -p "$out/bin"
    makeWrapper "$out/Applications/audacity.app/Contents/MacOS/audacity" "$out/bin/audacity"
  '';

  dontWrapGApps = true;
  # Automatic scanning would wrap bundled framework libraries as executables.
  dontWrapQtApps = stdenv.hostPlatform.isDarwin;

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "Sound editor with graphical UI";
    mainProgram = "audacity";
    homepage = "https://www.audacityteam.org";
    changelog = "https://github.com/audacity/audacity/releases/tag/Audacity-${finalAttrs.version}";
    license = lib.licenses.AND [
      lib.licenses.gpl2Plus
      lib.licenses.gpl3Only
      lib.licenses.cc-by-30
    ];
    maintainers = with lib.maintainers; [
      johnrichardrinehart
      veprbl
      wegank
    ];
    platforms = lib.platforms.unix;
  };
})
