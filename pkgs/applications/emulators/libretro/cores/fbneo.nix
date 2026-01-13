{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2026-01-11";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "aaecfedbb206a79d0e35a0dfe922622b921a66f7";
    hash = "sha256-Xn3lxXFf7EEism9CIGYhvP83oCpOTrpgnBAwkkB4TDM=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
