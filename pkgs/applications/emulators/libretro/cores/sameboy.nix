{
  lib,
  fetchFromGitHub,
  hexdump,
  mkLibretroCore,
  which,
}:
mkLibretroCore {
  core = "sameboy";
  version = "0-unstable-2026-04-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "sameboy";
    rev = "06c184f0b186f161bcdfec50ebd604fe789ed04a";
    hash = "sha256-sGEISpIGTHsUr4/DxMf5qxyTVdjmvWfqa2hUhj05jBA=";
  };

  extraNativeBuildInputs = [
    which
    hexdump
  ];
  preBuild = "cd libretro";
  makefile = "Makefile";

  meta = {
    description = "SameBoy libretro port";
    homepage = "https://github.com/libretro/SameBoy";
    license = lib.licenses.mit;
  };
}
