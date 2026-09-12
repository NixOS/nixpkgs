{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2026-09-01";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "1dfe2390661448ec148aeac4c85c9152c6e7441b";
    hash = "sha256-z7fzco9ycwIvG5D/fJVtbl7x34i9YRvD5p8AOrXjI0s=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
