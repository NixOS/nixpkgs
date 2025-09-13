{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2025-09-12";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "1f7783651749e42a0e580acb5f5a1b5f43cc1467";
    hash = "sha256-ltjBzAGfUrB5Rl+0ugI6HIFptiCwhfIDOCeUQpHJsR4=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
