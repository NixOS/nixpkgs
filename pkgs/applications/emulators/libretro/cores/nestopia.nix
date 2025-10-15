{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "nestopia";
  version = "0-unstable-2025-10-15";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "nestopia";
    rev = "3ac52e67c4a7fa696ee37e48bbcec93611277288";
    hash = "sha256-TDv+HTOtNEmel1lZlnlAGMVM8nEYdHLH7Rw6WBviGGw=";
  };

  makefile = "Makefile";
  preBuild = "cd libretro";

  meta = {
    description = "Nestopia libretro port";
    homepage = "https://github.com/libretro/nestopia";
    license = lib.licenses.gpl2Only;
  };
}
