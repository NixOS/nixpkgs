{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  alsa-lib,
  ffmpeg,
  kdePackages,
  kdsingleapplication,
  pipewire,
  taglib,
  libebur128,
  libvgm,
  libsndfile,
  libarchive,
  libopenmpt,
  game-music-emu,
  SDL2,
  icu,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fooyin";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "ludouzi";
    repo = "fooyin";
    tag = "v" + finalAttrs.version;
    hash = "sha256-549AtdldAPFengQsVXMnZI0mVzUwgKgUKAfR0Ro3s2I=";
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
    libvgm
    libsndfile
    libarchive
    libopenmpt
    game-music-emu
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
  ];

  env.LANG = "C.UTF-8";

  # Remove after next release
  patches = [
    (fetchpatch {
      name = "multi-track-fix.patch";
      url = "https://github.com/fooyin/fooyin/commit/cffe88058e96c44e563e927d8a4a903e28246020.patch";
      hash = "sha256-qNAR3xHZHzI/4RCWKzBbv1mX39xs7KMo/TpaDUYvSvc=";
    })
  ];

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
