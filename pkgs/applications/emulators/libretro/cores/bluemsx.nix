{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "bluemsx";
  version = "0-unstable-2025-11-04";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "bluemsx-libretro";
    rev = "036376d6679c9e153712dbbb3fdca774afc49706";
    hash = "sha256-0oT+m30bay/3BQgKBxX397a8o+QP1/IHIo0jGmSWGGg=";
  };

  meta = {
    description = "Port of BlueMSX to libretro";
    homepage = "https://github.com/libretro/blueMSX-libretro";
    license = lib.licenses.gpl2Only;
  };
}
