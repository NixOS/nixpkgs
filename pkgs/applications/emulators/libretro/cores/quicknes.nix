{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "quicknes";
  version = "0-unstable-2026-04-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "QuickNES_Core";
    rev = "7848e1ac22b1c69d056ae4cb57710651ff1dd169";
    hash = "sha256-cgoLO1572XoDDBJiEFglWtbo3vk5EXu/U3Pn7zrxqM8=";
  };

  makefile = "Makefile";

  meta = {
    description = "QuickNES libretro port";
    homepage = "https://github.com/libretro/QuickNES_Core";
    license = lib.licenses.lgpl21Plus;
  };
}
