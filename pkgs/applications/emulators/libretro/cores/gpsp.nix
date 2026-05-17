{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "gpsp";
  version = "0-unstable-2026-04-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "gpsp";
    rev = "eca3bee1e2d2043d42f0480012c1e7ec85498f88";
    hash = "sha256-GvS9HoHzT1Dr3OGLJFwMdB6+lw3vyKMRHzHuLdMxpY8=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of gpSP to libretro";
    homepage = "https://github.com/libretro/gpsp";
    license = lib.licenses.gpl2Only;
  };
}
