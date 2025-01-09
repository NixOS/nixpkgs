{
  lib,
  buildKodiBinaryAddon,
  fetchFromGitHub,
  libretro,
  fuse,
}:

buildKodiBinaryAddon rec {
  pname = "libretro-fuse";
  namespace = "game.libretro.fuse";
  version = "1.6.0.34";

  src = fetchFromGitHub {
    owner = "kodi-game";
    repo = "game.libretro.fuse";
    rev = "${version}-Nexus";
    hash = "sha256-MimwEV7YD6pMshxqbKTVbLDsPmMbqSy4HPnxwmKswpc=";
  };

  extraCMakeFlags = [
    "-DFUSE_LIB=${fuse}/lib/retroarch/cores/fuse_libretro.so"
  ];

  extraBuildInputs = [ fuse ];
  propagatedBuildInputs = [
    libretro
  ];

  meta = with lib; {
    homepage = "https://github.com/kodi-game/game.libretro.fuse";
    description = "Sinclair - ZX Spectrum (Fuse) GameClient for Kodi";
    platforms = platforms.all;
    license = licenses.gpl3Only;
    maintainers = with maintainers; teams.kodi.members ++ [ kazenyuk ];
  };
}
