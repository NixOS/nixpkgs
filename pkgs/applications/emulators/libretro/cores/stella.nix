{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "stella";
  version = "0-unstable-2026-02-25";

  src = fetchFromGitHub {
    owner = "stella-emu";
    repo = "stella";
    rev = "e0e8857f986bce1200881928193629a2105ae65d";
    hash = "sha256-Nw+G8VMS7YWfzgssvk5U2M506vVkgkA4Bnym0wpyfbw=";
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
