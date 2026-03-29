{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2026-03-28";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "7290e95232faacb0c31b0b12cb0884bb9f6e8cfc";
    hash = "sha256-vYryEUrYauVGGjmePCUnGdCpOGKUFxSI4tkFCt7wKs8=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
