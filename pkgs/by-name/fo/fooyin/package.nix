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
  game-music-emu,
  SDL2,
  icu,
  # Select bundled plugins to build. Leave empty for the default set, use none for no plugins, or use a semicolon/comma-separated list of plugin names to include or -name entries to exclude
  pluginSelection ? "",
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fooyin";
  version = "0.10.3";

  src = fetchFromGitHub {
    owner = "ludouzi";
    repo = "fooyin";
    tag = "v" + finalAttrs.version;
    hash = "sha256-mrERtHhmfEfK79pSEYFILW9WebtKVhbuXdQ52WTGa5A=";
  };

  buildInputs = [
    kdePackages.qcoro
    kdePackages.qtbase
    kdePackages.qtsvg
    kdePackages.qtwayland
    taglib
    ffmpeg
    icu
    kdsingleapplication
    # output plugins
    alsa-lib
    pipewire
    SDL2
    # input plugins
    libebur128
    libsndfile
    libarchive
    libopenmpt
    game-music-emu
    soundtouch
    soxr
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
    changelog = "https://github.com/fooyin/fooyin/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    downloadPage = "https://github.com/fooyin/fooyin";
    mainProgram = "fooyin";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ peterhoeg ];
    platforms = lib.platforms.linux;
  };
})
