{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2025-11-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "012dbe9dc11fd5fd765ef92e0ad4c08583862f69";
    hash = "sha256-hsv8eeU+/cuknyKQ7WNKrmRYu7kXLxu7bPkoVN9qZoE=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
