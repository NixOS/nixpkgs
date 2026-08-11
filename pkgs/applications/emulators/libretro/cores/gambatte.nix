{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "gambatte";
  version = "0-unstable-2026-07-31";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "gambatte-libretro";
    rev = "96174369b3c30d9fc57c926fa3379c273dc6a9a5";
    hash = "sha256-DEXyycFfQMK3RksP+4YxBIPYqmCFH4fM39MKxw6VOBU=";
  };

  meta = {
    description = "Gambatte libretro port";
    homepage = "https://github.com/libretro/gambatte-libretro";
    license = lib.licenses.gpl2Only;
  };
}
