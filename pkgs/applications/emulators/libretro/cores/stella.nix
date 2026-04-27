{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "stella";
  version = "0-unstable-2026-04-19";

  src = fetchFromGitHub {
    owner = "stella-emu";
    repo = "stella";
    rev = "8b7bc991d2500cbf2e861c25f96ff81e0d13f273";
    hash = "sha256-jeu/7hHuPfSoJg2/6UxUqHWOGMSe0vX6cgWLmVYHABQ=";
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
