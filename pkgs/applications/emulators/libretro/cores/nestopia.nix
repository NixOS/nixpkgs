{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "nestopia";
  version = "0-unstable-2025-08-09";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "nestopia";
    rev = "d33852f5efe89c87a06f8ce7d12b8b5451e9ae71";
    hash = "sha256-v/jXoXgVEIXpxBgHZ/6oL+YGPDv9jefwdetiqLFBN9I=";
  };

  makefile = "Makefile";
  preBuild = "cd libretro";

  meta = {
    description = "Nestopia libretro port";
    homepage = "https://github.com/libretro/nestopia";
    license = lib.licenses.gpl2Only;
  };
}
