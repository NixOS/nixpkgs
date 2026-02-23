{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2026-02-18";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "8046cc52643861f9af98b563477de6243b4fdd9b";
    hash = "sha256-hG0jAc4bMD334rPmUuj17OriGYynffZDhdhbHoDZYh4=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
