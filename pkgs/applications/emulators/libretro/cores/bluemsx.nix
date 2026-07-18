{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "bluemsx";
  version = "0-unstable-2026-07-04";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "bluemsx-libretro";
    rev = "fe7173f801fd2d6c3564ebe816797a44524e4bbf";
    hash = "sha256-NcDcFexU2jPWwQmWo9CK+jbYtEFiqZmzKLfrQrB9Cmg=";
  };

  meta = {
    description = "Port of BlueMSX to libretro";
    homepage = "https://github.com/libretro/blueMSX-libretro";
    license = lib.licenses.gpl2Only;
  };
}
