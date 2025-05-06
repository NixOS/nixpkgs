{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2025-04-24";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "8a1e2d68b1065cb1d3686e37b2643f54ab50f527";
    hash = "sha256-X1GWOHcIUnazno4ZkqlB+ugOtsAgADQqXFFBZy5OV4g=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
