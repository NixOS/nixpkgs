{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2025-12-05";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "db02ef59a64209954b47965ae186ec95cf1da706";
    hash = "sha256-lbtc/3lu+wm19rRt+gT3tHrDaqfZYVXsiHN5Pvm5iM8=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
