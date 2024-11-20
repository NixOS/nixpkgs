{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mednafen-pcfx";
  version = "0-unstable-2024-10-21";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "beetle-pcfx-libretro";
    rev = "dd04cef9355286488a1d78ff18c4c848a1575540";
    hash = "sha256-oFBuriCbJWjgPH9RRAM/XUvkW0gKXnvs7lmBpJpWewo=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of Mednafen's PCFX core to libretro";
    homepage = "https://github.com/libretro/beetle-pcfx-libretro";
    license = lib.licenses.gpl2Only;
  };
}
