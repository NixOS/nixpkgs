{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mednafen-pcfx";
  version = "0-unstable-2026-08-23";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "beetle-pcfx-libretro";
    rev = "0580dee757adfdb9bf8b9c24693dde5f3d0a78a1";
    hash = "sha256-4y0seZ2Jj3vUBiBL5+lT65YvmZi037rK7lXjCqaY90Y=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of Mednafen's PCFX core to libretro";
    homepage = "https://github.com/libretro/beetle-pcfx-libretro";
    license = lib.licenses.gpl2Only;
  };
}
