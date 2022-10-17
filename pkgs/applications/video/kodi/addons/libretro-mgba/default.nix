{ lib, rel, buildKodiBinaryAddon, fetchFromGitHub, libretro, mgba }:

buildKodiBinaryAddon rec {
  pname = "kodi-libretro-mgba";
  namespace = "game.libretro.mgba";
  version = "0.9.2.31";

  src = fetchFromGitHub {
    owner = "kodi-game";
    repo = "game.libretro.mgba";
    rev = "${version}-${rel}";
    sha256 = "sha256-eZLuNhLwMTtzpLGkymc9cLC83FQJWZ2ZT0iyz4sY4EA=";
  };

  extraCMakeFlags = [
    "-DMGBA_LIB=${mgba}/lib/retroarch/cores/mgba_libretro.so"
  ];

  extraBuildInputs = [ mgba ];
  propagatedBuildInputs = [
    libretro
  ];

  meta = with lib; {
    homepage = "https://github.com/kodi-game/game.libretro.mgba";
    description = "mGBA for Kodi";
    platforms = platforms.all;
    license = licenses.gpl2Only;
    maintainers = teams.kodi.members;
  };
}
