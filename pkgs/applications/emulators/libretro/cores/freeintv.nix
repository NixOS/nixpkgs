{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "freeintv";
  version = "0-unstable-2026-02-24";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "freeintv";
    rev = "0e0e58503386304c5e7ac860c135583bc52e2e49";
    hash = "sha256-uRkLF3LSiAMV/k8R8PuE0QZUnc1YEYe0rmccQz6H43A=";
  };

  makefile = "Makefile";

  meta = {
    description = "FreeIntv libretro port";
    homepage = "https://github.com/libretro/freeintv";
    license = lib.licenses.gpl3Only;
  };
}
