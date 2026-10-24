{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2026-10-15";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "7b8bdeeb25f64a41af896aaa71efed8a2b7f4076";
    hash = "sha256-d0uCGEJP3i77S3veuC0DZ4QD9NBVuE8f2i6/8Yi38VM=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
