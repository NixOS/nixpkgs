{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "gambatte";
  version = "0-unstable-2025-11-14";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "gambatte-libretro";
    rev = "6924c76ba03dadddc6e97fa3660f3d3bc08faa94";
    hash = "sha256-VhHPr+zM7YfwdxdhGQ8zkA/9r1ZYr4sgIr147DzKCJw=";
  };

  meta = {
    description = "Gambatte libretro port";
    homepage = "https://github.com/libretro/gambatte-libretro";
    license = lib.licenses.gpl2Only;
  };
}
