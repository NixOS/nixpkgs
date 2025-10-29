{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gitUpdater,
}:

stdenvNoCC.mkDerivation rec {
  pname = "retroarch-joypad-autoconfig";
  version = "1.21.1";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "retroarch-joypad-autoconfig";
    rev = "v${version}";
    hash = "sha256-yLxJaHvscNHvuX1ak1bQ1yGMYv5yO4gTj53neT+JsRo=";
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
    teams = [ teams.libretro ];
    platforms = platforms.all;
  };
}
