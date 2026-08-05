{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mednafen-ngp";
  version = "0-unstable-2026-06-14";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "beetle-ngp-libretro";
    rev = "a50d5ac288a81f2104ddf43195a4efdd15c72227";
    hash = "sha256-Zh+8JLkTcrLxjueQvaIhdOxHpl6Uf5ZRQ/cMNPHLVhk=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of Mednafen's NeoGeo Pocket core to libretro";
    homepage = "https://github.com/libretro/beetle-ngp-libretro";
    license = lib.licenses.gpl2Only;
  };
}
