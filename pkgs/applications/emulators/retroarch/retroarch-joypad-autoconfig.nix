{ lib
, stdenvNoCC
, fetchFromGitHub
, gitUpdater
}:

stdenvNoCC.mkDerivation rec {
  pname = "retroarch-joypad-autoconfig";
  version = "1.18.0";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "retroarch-joypad-autoconfig";
    rev = "v${version}";
    hash = "sha256-VZbdR9Tvc8FofBjApTskEZVwUzInEDM3YhZ14VWTyC0=";
  };

  makeFlags = [
    "PREFIX=$(out)"
  ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = with lib; {
    description = "Joypad autoconfig files";
    homepage = "https://www.libretro.com/";
    license = licenses.mit;
    maintainers = with maintainers; teams.libretro.members ++ [ ];
    platforms = platforms.all;
  };
}
