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

stdenv.mkDerivation rec {
  pname = "desmume";
  version = "0.9.11+unstable=2021-09-22";

  src = fetchFromGitHub {
    owner = "TASVideos";
    repo = pname;
    rev = "7fc2e4b6b6a58420de65a4089d4df3934d7a46b1";
    hash = "sha256-sTCyjQ31w1Lp+aa3VQ7/rdLbhjnqthce54mjKJZQIDM=";
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
  };
}
# TODO: investigate the patches
# TODO: investigate other platforms
