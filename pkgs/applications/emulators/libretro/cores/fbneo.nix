{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2025-07-24";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "ae41c16e10a1996e71ac7dd9a5484b725b8d1a51";
    hash = "sha256-mBlk4tjMd67dOw/+oYC0ly7u2Soqva4MxiODGXPjBrM=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
