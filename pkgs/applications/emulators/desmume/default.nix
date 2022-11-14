{ lib
, stdenv
, fetchFromGitHub
, SDL2
, agg
, alsa-lib
, desktop-file-utils
, gtk3
, intltool
, libGLU
, libXmu
, libpcap
, libtool
, lua
, meson
, ninja
, openal
, pkg-config
, soundtouch
, tinyxml
, zlib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "desmume";
  version = "0.9.13";

  src = fetchFromGitHub {
    owner = "TASVideos";
    repo = "desmume";
    rev = "release_${lib.replaceChars ["."] ["_"] finalAttrs.version}";
    hash = "sha256-vmjKXa/iXLTwtqnG+ZUvOnOQPZROeMpfM5J3Jh/Ynfo=";
  };

  nativeBuildInputs = [
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
    description = "An open-source Nintendo DS emulator";
    longDescription = ''
      DeSmuME is a freeware emulator for the NDS roms & Nintendo DS Lite games
      created by YopYop156 and now maintained by the TASvideos team. It supports
      many homebrew nds rom demoes as well as a handful of Wireless Multiboot
      demo nds roms. DeSmuME is also able to emulate nearly all of the
      commercial nds rom titles which other DS Emulators aren't.
    '';
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.unix;
    broken = stdenv.isAarch64 && stdenv.isLinux; # ofborg failed
  };
})
# TODO: investigate the patches
# TODO: investigate other platforms
