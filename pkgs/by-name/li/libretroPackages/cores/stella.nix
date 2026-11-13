{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "stella";
  version = "0-unstable-2026-11-04";

  src = fetchFromGitHub {
    owner = "stella-emu";
    repo = "stella";
    rev = "ba514174a445b7c224c93dcacb8f030da219fc76";
    hash = "sha256-lpNiSVBzh871xPGWafk68TU8VYwXxdq++klJbD4pPkg=";
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
