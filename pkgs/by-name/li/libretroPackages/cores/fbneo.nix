{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2026-10-26";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "32958a89abd645ed20387c8d31d21ede3bc48161";
    hash = "sha256-kVjaTroWc1/dJuf57SSPeKUNzFnVFi99bQ8WWCit62o=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
