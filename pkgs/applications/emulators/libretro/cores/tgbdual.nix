{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "tgbdual";
  version = "0-unstable-2025-05-10";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "tgbdual-libretro";
    rev = "933707c0ba8f12360f6d79712f735a917713709a";
    hash = "sha256-58OLuF14aSJGhmXR0RGgPpuHLXYk9LOz7LX03AEFPr4=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of TGBDual to libretro";
    homepage = "https://github.com/libretro/tgbdual-libretro";
    license = lib.licenses.gpl2Only;
  };
}
