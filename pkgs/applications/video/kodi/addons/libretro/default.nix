{
  lib,
  rel,
  buildKodiBinaryAddon,
  fetchFromGitHub,
  tinyxml,
}:

buildKodiBinaryAddon rec {
  pname = "libretro";
  namespace = "game.libretro";
  version = "20.1.0";

  src = fetchFromGitHub {
    owner = "kodi-game";
    repo = "game.libretro";
    rev = "${version}-${rel}";
    sha256 = "sha256-RwaLGAJt13PLKy45HU64TvQFyY532WWq2YX34Eyu+6o=";
  };

  extraBuildInputs = [ tinyxml ];

  meta = with lib; {
    homepage = "https://github.com/kodi-game/game.libretro";
    description = "Libretro wrapper for Kodi's Game API";
    platforms = platforms.all;
    license = licenses.gpl2Only;
    teams = [ teams.kodi ];
  };
}
