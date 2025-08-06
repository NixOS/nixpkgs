{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2025-08-01";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "e90b821fc0507a6bdde3596ec32b7b59feae1d1a";
    hash = "sha256-DbY+bQ4vNj4q2Q/tmEZXngdlUHqfZXTl16m14VG5gYY=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
