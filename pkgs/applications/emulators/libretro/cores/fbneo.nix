{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2026-05-09";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "776ae715211d3ef2413b2828e9e9d50d869a6822";
    hash = "sha256-NgPs8H8/ysD18J2G9StaLM5e05EzgjLW8c2kTrcOXZI=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
