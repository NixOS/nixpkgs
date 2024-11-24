{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "81";
  version = "0-unstable-2024-10-21";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "81-libretro";
    rev = "ffc99f27f092addc9ddd34dd0e3a3d4d1c053cbf";
    hash = "sha256-3AIXk3LJHZHWIojMeo2BJHWYDHQ17WVbkwjFhXM14ZE=";
  };

  meta = {
    description = "Port of EightyOne to libretro";
    homepage = "https://github.com/libretro/81-libretro";
    license = lib.licenses.gpl3Only;
  };
}
