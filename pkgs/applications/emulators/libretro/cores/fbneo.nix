{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2025-09-30";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "9726100ba22a558290860a2648e1e6a8b8719478";
    hash = "sha256-mhXuHPwXtvuA8ltaLF3uOsBwLE0evJ2RiCrNX5hnRXM=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
