{ lib, rel, buildKodiBinaryAddon, fetchFromGitHub, libretro, genesis-plus-gx }:

buildKodiBinaryAddon rec {
  pname = "kodi-libretro-genplus";
  namespace = "game.libretro.genplus";
  version = "1.7.4.31";

  src = fetchFromGitHub {
    owner = "kodi-game";
    repo = "game.libretro.genplus";
    rev = "${version}-${rel}";
    sha256 = "0lcii32wzpswjjkwhv250l238g31akr66dhkbv8gj4v1i4z7hry8";
  };

  extraCMakeFlags = [
    "-DGENPLUS_LIB=${genesis-plus-gx}/lib/retroarch/cores/genesis_plus_gx_libretro.so"
  ];

  extraBuildInputs = [ genesis-plus-gx ];
  propagatedBuildInputs = [
    libretro
  ];

  meta = with lib; {
    homepage = "https://github.com/kodi-game/game.libretro.genplus";
    description = "Genesis Plus GX GameClient for Kodi";
    platforms = platforms.all;
    license = licenses.gpl2Only;
    maintainers = teams.kodi.members;
  };
}
