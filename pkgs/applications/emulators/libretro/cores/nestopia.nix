{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "nestopia";
  version = "0-unstable-2025-03-16";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "nestopia";
    rev = "83d4f6227d14c817c8c75d2b6ad69514acb8fc4b";
    hash = "sha256-3BTQbtascDymbJK1ECjaoE9z1fVMnmvcdO+c4aCWuFE=";
  };

  makefile = "Makefile";
  preBuild = "cd libretro";

  meta = {
    description = "Nestopia libretro port";
    homepage = "https://github.com/libretro/nestopia";
    license = lib.licenses.gpl2Only;
  };
}
