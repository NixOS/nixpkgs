{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "neocd";
  version = "0-unstable-2026-04-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "neocd_libretro";
    rev = "9e9ad181bed60f84f9cff02c03617b41e8a31cfe";
    hash = "sha256-1rmoV6jxClTSRWNzsYepP8VSHKbSB+HUOLkvRrvYz/c=";
  };

  makefile = "Makefile";

  meta = {
    description = "NeoCD libretro port";
    homepage = "https://github.com/libretro/neocd_libretro";
    license = lib.licenses.lgpl3Only;
  };
}
