{
  lib,
  rel,
  buildKodiBinaryAddon,
  fetchFromGitHub,
  libretro,
  fbneo,
}:

buildKodiBinaryAddon rec {
  pname = "libretro-fbneo";
  namespace = "game.libretro.fbneo";
  version = "1.0.0.81";

  src = fetchFromGitHub {
    owner = "kodi-game";
    repo = "game.libretro.fbneo";
    rev = "${version}-${rel}";
    hash = "sha256-+stktDSoaz4fJGPIVuxlGuA2il/WC1cLhUPVvRM6CuU=";
  };

  extraCMakeFlags = [
    "-DFBNEO_LIB=${fbneo}/lib/retroarch/cores/fbneo_libretro.so"
  ];

  extraBuildInputs = [ fbneo ];
  propagatedBuildInputs = [ libretro ];

  meta = with lib; {
    homepage = "https://github.com/kodi-game/game.libretro.fbneo";
    description = "FinalBurn Neo GameClient for Kodi (previously FinalBurn Alpha)";
    platforms = platforms.all;
    license = licenses.gpl2Only;
    maintainers = teams.kodi.members;
  };
}
