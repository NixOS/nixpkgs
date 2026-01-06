{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "vbam";
  version = "0-unstable-2026-01-04";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "vbam-libretro";
    rev = "894948f85303253d4e70ae03c9eff8865d95f427";
    hash = "sha256-0KgCJSYn0PUL/5cGLzFEfRCAMtsdY4N6wY5hbNteRFI=";
  };

  makefile = "Makefile";
  preBuild = "cd src/libretro";

  meta = {
    description = "VBA-M libretro port";
    homepage = "https://github.com/libretro/vbam-libretro";
    license = lib.licenses.gpl2Only;
  };
}
