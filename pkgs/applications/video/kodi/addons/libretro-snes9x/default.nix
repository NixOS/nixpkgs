{ lib, rel, buildKodiBinaryAddon, fetchFromGitHub, libretro, snes9x }:

buildKodiBinaryAddon rec {
  pname = "kodi-libretro-snes9x";
  namespace = "game.libretro.snes9x";
  version = "1.60.0.29";

  src = fetchFromGitHub {
    owner = "kodi-game";
    repo = "game.libretro.snes9x";
    rev = "${version}-${rel}";
    sha256 = "1wyfkg4fncc604alnbaqk92fi1h80n7bwiqfkb8479x5517byab1";
  };

  extraCMakeFlags = [
    "-DSNES9X_LIB=${snes9x}/lib/retroarch/cores/snes9x_libretro.so"
  ];

  extraBuildInputs = [ snes9x ];
  propagatedBuildInputs = [
    libretro
  ];

  meta = with lib; {
    homepage = "https://github.com/kodi-game/game.libretro.snes9x";
    description = "Snes9X GameClient for Kodi";
    platforms = platforms.all;
    license = licenses.gpl2Only;
    maintainers = teams.kodi.members;
  };
}
