{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "gambatte";
  version = "0-unstable-2026-05-15";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "gambatte-libretro";
    rev = "3262c2aa4adae8dba4f6d51cdd931c15cb11569f";
    hash = "sha256-JPnpY/43XbT9QnvzrYPkZLCcM3hN+SoQTFZ8J/Dj+Oc=";
  };

  meta = {
    description = "Gambatte libretro port";
    homepage = "https://github.com/libretro/gambatte-libretro";
    license = lib.licenses.gpl2Only;
  };
}
