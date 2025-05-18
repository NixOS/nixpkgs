{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  SDL2,
  agg,
  alsa-lib,
  desktop-file-utils,
  wrapGAppsHook3,
  gtk3,
  intltool,
  libGLU,
  libXmu,
  libpcap,
  libtool,
  lua,
  meson,
  ninja,
  openal,
  pkg-config,
  soundtouch,
  tinyxml,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "desmume";
  version = "0.9.13";

  src = fetchFromGitHub {
    owner = "TASVideos";
    repo = "desmume";
    rev = "release_${lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    hash = "sha256-vmjKXa/iXLTwtqnG+ZUvOnOQPZROeMpfM5J3Jh/Ynfo=";
  };

  patches = [
    # Fix compiling on GCC for AArch64
    (fetchpatch {
      url = "https://github.com/TASEmulators/desmume/commit/24eb5ed95c6cbdaba8b3c63a99e95e899e8a5061.patch";
      hash = "sha256-J3ZRU1tPTl+4/jg0DBo6ro6DTUZkpQCey+QGF2EugCQ=";
    })

    # Fix strdup implicit declaration errors
    (fetchpatch {
      url = "https://github.com/TASEmulators/desmume/commit/738298a9e887bf7220fed026cb872a544fd60431.patch?full_index=1";
      hash = "sha256-JNq++g6olaKsNa1XIs9Zz1YQxAsN3vAuFkykdlrfzaQ=";
    })
  ];

  nativeBuildInputs = [
    wrapGAppsHook3
    desktop-file-utils
    intltool
    libtool
    lua
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    SDL2
    agg
    alsa-lib
    gtk3
    libGLU
    libXmu
    libpcap
    openal
    soundtouch
    tinyxml
    zlib
  ];

  hardeningDisable = [ "format" ];

  preConfigure = ''
    cd desmume/src/frontend/posix
  '';

  mesonFlags = [
    "-Db_pie=true"
    "-Dopenal=true"
    "-Dwifi=true"
  ];

  meta = with lib; {
    homepage = "https://www.github.com/TASVideos/desmume/";
    description = "Open-source Nintendo DS emulator";
    longDescription = ''
      DeSmuME is a freeware emulator for the NDS roms & Nintendo DS Lite games
      created by YopYop156 and now maintained by the TASvideos team. It supports
      many homebrew nds rom demoes as well as a handful of Wireless Multiboot
      demo nds roms. DeSmuME is also able to emulate nearly all of the
      commercial nds rom titles which other DS Emulators aren't.
    '';
    license = licenses.gpl2Plus;
    maintainers = [ ];
    platforms = platforms.unix;
  };
})
