{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  ncurses,
  libevdev,
  SDL2,
  SDL2_image,
  libglvnd,
  libslirp,
  libdeflate,
  zlib,
  boost,
  libpcap,
  xxd,
  libnl,
  libtiff,
  libjpeg,
  libwebp,
  libpng,
  xz,
  libsysprof-capture,
  lerc,
  libx11,
  libxext,
  qt6Packages,
  qt6,
  enableQt6 ? true,
  enableNcurses ? true,
  enableSdl2 ? true,
  enableLibretro ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "applewin";
  version = "1.30.21.0.b";

  src = fetchFromGitHub {
    owner = "audetto";
    repo = "AppleWin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-g1780lODOsnjlUYzapvkmJMGh8ovOHRAfyl+1E1wHNY=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    xxd
  ]
  ++ lib.optionals enableQt6 [
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    ncurses
    libevdev
    SDL2
    SDL2_image
    libglvnd
    libslirp
    xz
    lerc
    libsysprof-capture
    libdeflate
    zlib
    boost
    libpcap
    libnl
    libtiff
    libjpeg
    libwebp
    libpng
    libx11
    libxext
  ]
  ++ lib.optionals enableQt6 [
    qt6Packages.qtbase
    qt6Packages.qtmultimedia
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_APPLEN" enableNcurses)
    (lib.cmakeBool "BUILD_QAPPLE" enableQt6)
    (lib.cmakeBool "BUILD_SA2" enableSdl2)
    (lib.cmakeBool "BUILD_LIBRETRO" enableLibretro)
  ];

  meta = {
    description = "Apple II emulator for Linux";
    longDescription = ''
      AppleWin on Linux is a linux port of AppleWin that shares 100% of the code
      of the core emulator and video generation. Audio, UI, scheduling and other
      peripherals are reimplemented.
    '';
    homepage = "https://github.com/audetto/AppleWin";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.matthewcroughan ];
    platforms = lib.platforms.linux;
    mainProgram = "qapple";
  };
})
