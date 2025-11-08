{
  lib,
  buildKodiBinaryAddon,
  fetchFromGitHub,
  libretro,
  twenty-fortyeight,
}:

buildKodiBinaryAddon rec {
  pname = "libretro-2048";
  namespace = "game.libretro.2048";
  version = "1.0.0.136";

  src = fetchFromGitHub {
    owner = "kodi-game";
    repo = "game.libretro.2048";
    rev = "${version}-Nexus";
    hash = "sha256-cIo56ZGansBlAj6CFw51UOYJUivN9n1qhVTWAX9c5Tc=";
  };

  extraCMakeFlags = [
    "-D2048_LIB=${twenty-fortyeight}/lib/retroarch/cores/2048_libretro.so"
  ];

  extraBuildInputs = [ twenty-fortyeight ];
  propagatedBuildInputs = [
    libretro
  ];

  meta = with lib; {
    homepage = "https://github.com/kodi-game/game.libretro.2048";
    description = "2048 GameClient for Kodi";
    platforms = platforms.all;
    license = licenses.publicDomain;
    maintainers = with maintainers; [ kazenyuk ];
    teams = [ teams.kodi ];
  };
}
