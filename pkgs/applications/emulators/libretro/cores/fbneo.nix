{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2025-08-19";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "7345d0f50079ca989e3685152687f1ee15bad829";
    hash = "sha256-MohvlQtLtDq6GGOL3nAbRGUdbJDnc0nTgSQKlUGWDBU=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
