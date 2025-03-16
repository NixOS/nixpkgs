{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2025-03-11";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "0bf8e4482caf9c18fcd74b3ddd2d7eaaf32ff8ef";
    hash = "sha256-vIC1S57z+agpuaY7wb5bVAppsZkxCQGEnQteiHu0Y34=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
