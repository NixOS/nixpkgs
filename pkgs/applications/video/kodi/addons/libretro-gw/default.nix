{
  lib,
  rel,
  buildKodiBinaryAddon,
  fetchFromGitHub,
  libretro,
  gw,
}:

buildKodiBinaryAddon rec {
  pname = "libretro-gw";
  namespace = "game.libretro.gw";
  version = "1.6.3.34";

  src = fetchFromGitHub {
    owner = "kodi-game";
    repo = "game.libretro.gw";
    rev = "${version}-${rel}";
    hash = "sha256-HYXR3cEjbdKgKy42nq36Ii3UyxRVuQVROQjyaxSp5Ro=";
  };

  extraCMakeFlags = [
    "-DGW_LIB=${gw}/lib/retroarch/cores/gw_libretro.so"
  ];

  extraBuildInputs = [ gw ];
  propagatedBuildInputs = [
    libretro
  ];

  meta = with lib; {
    homepage = "https://github.com/kodi-game/game.libretro.gw";
    description = "Game and Watch for Kodi";
    platforms = platforms.all;
    license = licenses.gpl2Only;
    teams = [ teams.kodi ];
  };
}
