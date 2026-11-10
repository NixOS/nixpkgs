{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mednafen-supafaust";
  version = "0-unstable-2026-08-23";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "supafaust";
    rev = "642d1d1b6684aa7e306a02a89885f3f5456a5157";
    hash = "sha256-malpQAapdRY/V4y2Csm36+Bo1WCRcAWnx4C4okC5S4k=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of Mednafen's experimental snes_faust core to libretro";
    homepage = "https://github.com/libretro/supafaust";
    license = lib.licenses.gpl2Only;
  };
}
