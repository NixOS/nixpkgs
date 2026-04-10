{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2026-04-06";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "f659af2c3bec122d3e628e1e1634e746e67005e4";
    hash = "sha256-cK2c611fBEDcRK1I7VMLL+Ih76FMWlEGhmhg53KampU=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
