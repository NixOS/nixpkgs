{ lib
, stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation rec {
  pname = "retroarch-joypad-autoconfig";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "retroarch-joypad-autoconfig";
    rev = "v${version}";
    hash = "sha256-/F2Y08uDA/pIIeLiLfOQfGVjX2pkuOqPourlx2RbZ28=";
  };

  makeFlags = [
    "PREFIX=$(out)"
  ];

  meta = with lib; {
    description = "Joypad autoconfig files";
    homepage = "https://www.libretro.com/";
    license = licenses.mit;
    maintainers = with maintainers; teams.libretro.members ++ [ ];
    platforms = platforms.all;
  };
}
