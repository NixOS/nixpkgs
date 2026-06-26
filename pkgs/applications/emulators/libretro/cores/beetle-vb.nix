{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mednafen-vb";
  version = "0-unstable-2026-06-14";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "beetle-vb-libretro";
    rev = "38e7a0ec9ac7079ca1c1e3dd9aaf5b56f527efca";
    hash = "sha256-+57qsfH2wygKdD66yauzKD9XDf01q4LeiWdIeYbVUmc=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of Mednafen's VirtualBoy core to libretro";
    homepage = "https://github.com/libretro/beetle-vb-libretro";
    license = lib.licenses.gpl2Only;
  };
}
