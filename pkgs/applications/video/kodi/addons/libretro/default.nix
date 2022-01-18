{ lib, rel, buildKodiBinaryAddon, fetchFromGitHub, tinyxml }:

buildKodiBinaryAddon rec {
  pname = "libretro";
  namespace = "game.libretro";
  version = "19.0.0";

  src = fetchFromGitHub {
    owner = "kodi-game";
    repo = "game.libretro";
    rev = "${version}-${rel}";
    sha256 = "1831wbbc4a545lr4mg1fm4sbx75k5lkrfqaa5fh308aar0nm974d";
  };

  extraBuildInputs = [ tinyxml ];

  meta = with lib; {
    homepage = "https://github.com/kodi-game/game.libretro";
    description = "Libretro wrapper for Kodi's Game API";
    platforms = platforms.all;
    license = licenses.gpl2Only;
    maintainers = teams.kodi.members;
  };
}
