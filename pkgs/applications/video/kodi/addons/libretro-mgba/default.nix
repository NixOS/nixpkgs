{
  lib,
  buildKodiBinaryAddon,
  fetchFromGitHub,
  libretro,
  mgba,
}:

buildKodiBinaryAddon rec {
  pname = "kodi-libretro-mgba";
  namespace = "game.libretro.mgba";
  version = "0.10.0.35";

  src = fetchFromGitHub {
    owner = "kodi-game";
    repo = "game.libretro.mgba";
    rev = "${version}-Matrix";
    sha256 = "sha256-lxpj6Y34apYcE22q4W3Anhigp79r4RgiJ36DbES1kzU=";
  };

  extraCMakeFlags = [
    "-DMGBA_LIB=${mgba}/lib/retroarch/cores/mgba_libretro.so"
  ];

  extraBuildInputs = [ mgba ];
  propagatedBuildInputs = [
    libretro
  ];

  meta = {
    homepage = "https://github.com/kodi-game/game.libretro.mgba";
    description = "mGBA for Kodi";
    platforms = lib.platforms.all;
    license = lib.licenses.gpl2Only;
    teams = [ lib.teams.kodi ];
  };
}
