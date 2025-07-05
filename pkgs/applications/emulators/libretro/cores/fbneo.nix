{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2025-06-29";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "efed0db8b8fc46bd7683c73ce2d6c6b89434f37f";
    hash = "sha256-ioBRyvao/HBjWsej8GIMDrVa7zNGk2BG1lyMWijxogY=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
