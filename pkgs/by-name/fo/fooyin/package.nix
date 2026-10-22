{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  alsa-lib,
  ffmpeg,
  kdePackages,
  kdsingleapplication,
  pipewire,
  taglib,
  libebur128,
  libsndfile,
  libarchive,
  libopenmpt,
  soundtouch,
  soxr,
  libpulseaudio,
  libprojectm,
  libcdio,
  libcdio-paranoia,
  game-music-emu,
  SDL2,
  icu,
  zlib,
  jack2,
  flac,
  mpg123,
  opusfile,
  libvorbis,
  # Select bundled plugins to build. Leave empty for the default set, use none for no plugins, or use a semicolon/comma-separated list of plugin names to include or -name entries to exclude
  pluginSelection ? "",
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fooyin";
  version = "0.14.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "fooyin";
    repo = "fooyin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-z1EtohIftZ7GN+uu28QrD2Ya8lfzE1TtreWh6dfEoI0=";
  };

  buildInputs = [
    # list from fooyin's BUILD.md
    kdePackages.qcoro
    kdePackages.qtbase
    kdePackages.qtsvg
    kdePackages.qtwayland
    taglib
    ffmpeg
    icu
    kdsingleapplication
    zlib
    libarchive
    # output plugins
    alsa-lib
    jack2
    pipewire
    libpulseaudio
    SDL2
    # input plugins
    libsndfile
    flac
    mpg123
    opusfile
    libvorbis
    libopenmpt
    game-music-emu
    libebur128
    libcdio
    libcdio-paranoia
    soundtouch
    soxr
    libprojectm
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    kdePackages.qttools
    kdePackages.wrapQtAppsHook
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.finalPackage.doCheck)
    # we need INSTALL_FHS to be true as the various artifacts are otherwise just dumped in the root
    # of $out and the fixupPhase cleans things up anyway
    (lib.cmakeBool "INSTALL_FHS" true)
    (lib.cmakeFeature "PLUGIN_SELECTION" pluginSelection)
  ];

  env.LANG = "C.UTF-8";

  meta = {
    description = "Customisable music player";
    homepage = "https://www.fooyin.org/";
    changelog = "https://github.com/fooyin/fooyin/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    downloadPage = "https://github.com/fooyin/fooyin";
    mainProgram = "fooyin";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      peterhoeg
      alden
      keenanweaver
    ];
    platforms = lib.platforms.linux;
  };
})
