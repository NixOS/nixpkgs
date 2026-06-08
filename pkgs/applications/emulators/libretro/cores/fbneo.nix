{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2026-06-04";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "298f913aeb781908c7f6a568a2ede3940a98738d";
    hash = "sha256-UP0jNsqXMzrO+EQY8Gbkl2lIizfsAKoKiGaXGp7Nok8=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
