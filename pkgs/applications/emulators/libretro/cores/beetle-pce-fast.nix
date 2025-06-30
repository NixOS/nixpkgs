{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mednafen-pce-fast";
  version = "0-unstable-2025-06-27";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "beetle-pce-fast-libretro";
    rev = "04a6f2e85c7b4e79bb1bb402a8ea7d8f55132ad3";
    hash = "sha256-xA2owDEe9o0+roxZ+GBM4LD7sBDGC9ZY5atwWVA8HC8=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of Mednafen's PC Engine fast core to libretro";
    homepage = "https://github.com/libretro/beetle-pce-fast-libretro";
    license = lib.licenses.gpl2Only;
  };
}
