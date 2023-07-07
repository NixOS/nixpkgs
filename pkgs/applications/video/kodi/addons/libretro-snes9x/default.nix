{ lib, buildKodiBinaryAddon, fetchFromGitHub, libretro, snes9x }:

buildKodiBinaryAddon rec {
  pname = "kodi-libretro-snes9x";
  namespace = "game.libretro.snes9x";
  version = "1.61.0.34";

  src = fetchFromGitHub {
    owner = "kodi-game";
    repo = "game.libretro.snes9x";
    rev = "${version}-Matrix";
    sha256 = "sha256-LniZf8Gae4+4Rgc9OGhMCkOI3IA7CPjVrN/gbz9te38=";
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
