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
  ];

  preConfigure = ''
    cmakeFlagsArray+=("-DEXTDEPS_CACHE=$PWD/offline-deps")
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

  dontWrapGApps = true;

  strictDeps = true;

  doCheck = false;

  meta = {
    description = "Sound editor with graphical UI";
    mainProgram = "audacity";
    homepage = "https://www.audacityteam.org";
    changelog = "https://github.com/audacity/audacity/releases/tag/Audacity-${finalAttrs.version}";
    license = with lib.licenses; [
      gpl2Plus
      gpl3
      cc-by-30
    ];
    maintainers = with lib.maintainers; [
      veprbl
      wegank
    ];
    platforms = lib.platforms.unix;
  };
})
