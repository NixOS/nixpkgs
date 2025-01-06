{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gitUpdater,
}:

stdenvNoCC.mkDerivation rec {
  pname = "retroarch-joypad-autoconfig";
  version = "1.19.0";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "retroarch-joypad-autoconfig";
    rev = "v${version}";
    hash = "sha256-iwxTMwGHix2K5UyjBWFamyo3nVULxwbIF+djyQWz5L0=";
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
    maintainers = with lib.maintainers; lib.teams.libretro.members ++ [ ];
    platforms = lib.platforms.all;
  };
}
