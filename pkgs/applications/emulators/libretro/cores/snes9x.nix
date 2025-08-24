{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "snes9x";
  version = "0-unstable-2025-08-11";

  src = fetchFromGitHub {
    owner = "snes9xgit";
    repo = "snes9x";
    rev = "b33f2afb33c61d675aaf0319bd3b8cc8d6924d49";
    hash = "sha256-hhe52Ob+WC+wktXIYUoEfOq/FKyKGfeeX+BYyQ3xgXE=";
  };

  makefile = "Makefile";
  preBuild = "cd libretro";

  meta = {
    description = "Port of SNES9x git to libretro";
    homepage = "https://github.com/snes9xgit/snes9x";
    license = lib.licenses.unfreeRedistributable;
  };
}
