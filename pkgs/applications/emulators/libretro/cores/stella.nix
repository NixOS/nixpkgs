{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "stella";
  version = "0-unstable-2026-02-13";

  src = fetchFromGitHub {
    owner = "stella-emu";
    repo = "stella";
    rev = "9d7d1d2d6cc571821a8aa2459b9c1c914947cbd6";
    hash = "sha256-YE+LTuGUJN1mGEyK+aJgivYkMEjI+1ISwmWYDypm/a0=";
  };

  makefile = "Makefile";
  preBuild = "cd src/os/libretro";
  dontConfigure = true;

  meta = {
    description = "Port of Stella to libretro";
    homepage = "https://github.com/stella-emu/stella";
    license = lib.licenses.gpl2Only;
  };
}
