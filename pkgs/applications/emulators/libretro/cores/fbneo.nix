{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2025-07-18";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "9491dab32de7d70c51a3d9fec6e17d1ea7e52a3f";
    hash = "sha256-x0gBSSjbM/neIwjA7qmi5gvSGmeyaRNmDs2z9awakXY=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
