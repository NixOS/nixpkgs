{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fmsx";
  version = "0-unstable-2024-06-28";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fmsx-libretro";
    rev = "cf97a3c6da07d5f8e98c90c907ad987ffea432e0";
    hash = "sha256-mPgmt05XDnB+eIWtOpBfZ37Cz24VBei1lLLaYsJNeAA=";
  };

  makefile = "Makefile";

  meta = {
    description = "FMSX libretro port";
    homepage = "https://github.com/libretro/fmsx-libretro";
    license = lib.licenses.unfreeRedistributable;
  };
}
