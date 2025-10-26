{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "vbam";
  version = "0-unstable-2025-10-17";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "vbam-libretro";
    rev = "badf47c0e050983e44ac1217033283ca78313298";
    hash = "sha256-PwqwG+YMgdWNMoWx0mdUIBebQBMgaFd8BiI27xSUhps=";
  };

  makefile = "Makefile";
  preBuild = "cd src/libretro";

  meta = {
    description = "VBA-M libretro port";
    homepage = "https://github.com/libretro/vbam-libretro";
    license = lib.licenses.gpl2Only;
  };
}
