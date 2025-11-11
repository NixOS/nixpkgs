{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2025-11-06";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "7759881be43b5f1711c95a2a80aa8987a98fbb99";
    hash = "sha256-vYHWJV5xRACjdllmeg/3tr2WgI4QcWtuhKJhEwGIGD0=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
