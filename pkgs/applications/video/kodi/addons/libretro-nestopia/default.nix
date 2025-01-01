{
  lib,
  rel,
  buildKodiBinaryAddon,
  fetchFromGitHub,
  libretro,
  nestopia,
}:

buildKodiBinaryAddon rec {
  pname = "libretro-nestopia";
  namespace = "game.libretro.nestopia";
  version = "1.52.0.41";

  src = fetchFromGitHub {
    owner = "kodi-game";
    repo = "game.libretro.nestopia";
    rev = "${version}-${rel}";
    sha256 = "sha256-DmBO+HcfIBcz7p16dND09iwXWeObtU/doo/mJ0IZGGg=";
  };

  extraCMakeFlags = [
    "-DNESTOPIA_LIB=${nestopia}/lib/retroarch/cores/nestopia_libretro.so"
  ];

  extraBuildInputs = [ nestopia ];
  propagatedBuildInputs = [
    libretro
  ];

  meta = with lib; {
    homepage = "https://github.com/kodi-game/game.libretro.nestopia";
    description = "Nintendo - NES / Famicom (Nestopia UE) GameClient for Kodi";
    platforms = platforms.all;
    license = licenses.gpl2Only;
    maintainers = teams.kodi.members;
  };
}
