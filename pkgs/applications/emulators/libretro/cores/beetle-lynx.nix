{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mednafen-lynx";
  version = "0-unstable-2025-05-10";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "beetle-lynx-libretro";
    rev = "efd1797c7aa5a83c354507b1b61ac24222ebaa58";
    hash = "sha256-K+VZYqNl3G1eE7dSlfmZFCoS5bKIyGSNNu2i737bKnM=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of Mednafen's Lynx core to libretro";
    homepage = "https://github.com/libretro/beetle-lynx-libretro";
    license = lib.licenses.gpl2Only;
  };
}
