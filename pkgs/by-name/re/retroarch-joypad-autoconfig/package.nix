{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gitUpdater,
}:

stdenvNoCC.mkDerivation rec {
  pname = "retroarch-joypad-autoconfig";
  version = "1.22.0";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "retroarch-joypad-autoconfig";
    rev = "v${version}";
    hash = "sha256-j49K3uvi3cJeAfwC1olgmLAAOjK9IAv6fJYuamQJjDk=";
  };

  makeFlags = [
    "PREFIX=$(out)"
  ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = {
    description = "Joypad autoconfig files";
    homepage = "https://www.libretro.com/";
    license = lib.licenses.mit;
    teams = [ lib.teams.libretro ];
    platforms = lib.platforms.all;
  };
}
