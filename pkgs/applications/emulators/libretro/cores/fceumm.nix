{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fceumm";
  version = "0-unstable-2025-02-12";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-fceumm";
    rev = "26f92531a95a9a74f45a8bf13fc9f3f48cde2976";
    hash = "sha256-XtSuZEfu03dFMQUX4VvpeFLzoWG3TeIBQG4cQkap+t8=";
  };

  meta = {
    description = "FCEUmm libretro port";
    homepage = "https://github.com/libretro/libretro-fceumm";
    license = lib.licenses.gpl2Only;
  };
}
