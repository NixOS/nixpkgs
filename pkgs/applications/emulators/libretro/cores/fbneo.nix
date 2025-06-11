{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2025-06-09";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "a087cca4b133bdb7bb5d8d359500a0bf663928b8";
    hash = "sha256-Z3WB4d9me7PDwOsICRdz+u93MTSkTGt8vZtfRvZEcEw=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
