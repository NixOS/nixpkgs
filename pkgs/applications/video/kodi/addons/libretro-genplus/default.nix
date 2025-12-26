{
  lib,
  buildKodiBinaryAddon,
  fetchFromGitHub,
  libretro,
  genesis-plus-gx,
}:

buildKodiBinaryAddon rec {
  pname = "kodi-libretro-genplus";
  namespace = "game.libretro.genplus";
  version = "1.7.4.35";

  src = fetchFromGitHub {
    owner = "kodi-game";
    repo = "game.libretro.genplus";
    rev = "${version}-Matrix";
    sha256 = "sha256-F3bt129lBZKlDtp7X0S0q10T9k9C2zNeHG+yIP3818Q=";
  };

  extraCMakeFlags = [
    "-DGENPLUS_LIB=${genesis-plus-gx}/lib/retroarch/cores/genesis_plus_gx_libretro.so"
  ];

  extraBuildInputs = [ genesis-plus-gx ];
  propagatedBuildInputs = [
    libretro
  ];

  meta = {
    homepage = "https://github.com/kodi-game/game.libretro.genplus";
    description = "Genesis Plus GX GameClient for Kodi";
    platforms = lib.platforms.all;
    license = lib.licenses.gpl2Only;
    teams = [ lib.teams.kodi ];
  };
}
