{ lib, buildKodiBinaryAddon, fetchFromGitHub, libretro, mupen64plus }:

buildKodiBinaryAddon rec {
  pname = "kodi-libretro-mupen64plus-nx";
  namespace = "game.libretro.mupen64plus-nx";
  version = "2.5.0.41";

  src = fetchFromGitHub {
    owner = "kodi-game";
    repo = "game.libretro.mupen64plus-nx";
    rev = "${version}-Nexus";
    sha256 = "sha256-LKTf2i6nsQVJ/Id3jstxIiIQxGobiWhfSwjBgQ+zRnQ=";
  };

  extraCMakeFlags = [
    "-DMUPEN64PLUS-NX_LIB=${mupen64plus}/lib/retroarch/cores/mupen64plus_next_libretro.so"
  ];

  extraBuildInputs = [ mupen64plus ];
  propagatedBuildInputs = [
    libretro
  ];

  meta = with lib; {
    homepage = "https://github.com/kodi-game/game.libretro.mupen64plus-nx";
    description = "Mupen64plus GameClient for Kodi";
    platforms = platforms.all;
    license = licenses.gpl2Only;
    maintainers = teams.kodi.members;
  };
}
