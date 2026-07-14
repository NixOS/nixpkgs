{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "nxengine";
  version = "0-unstable-2026-04-09";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "nxengine-libretro";
    rev = "a1c45fd4d045333f4ea523e556469b545be82b0a";
    hash = "sha256-v7mUr4GeNc/bOe4gQvtPns4/uLA+r7UFGavDdtBNj6E=";
  };

  makefile = "Makefile";

  meta = {
    description = "NXEngine libretro port";
    homepage = "https://github.com/libretro/nxengine-libretro";
    license = lib.licenses.gpl3Only;
  };
}
