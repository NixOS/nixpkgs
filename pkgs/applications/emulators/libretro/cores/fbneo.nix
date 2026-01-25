{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2026-01-23";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "af33e4d8f11336d6902bff0874309066a405cadf";
    hash = "sha256-huEZOcS9/ImbuL9snSPdk4uqG2kS37eyiVErZ4z58c8=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
