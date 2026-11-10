{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "vba-next";
  version = "0-unstable-2026-08-31";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "vba-next";
    rev = "788192f215ad0a1413f1625b40ebba3423fa0ade";
    hash = "sha256-pxVno0flMRpdZiNeqOYZjjA7hzy6nmlwW0IbuLY6bFQ=";
  };

  meta = {
    description = "VBA-M libretro port with modifications for speed";
    homepage = "https://github.com/libretro/vba-next";
    license = lib.licenses.gpl2Only;
  };
}
