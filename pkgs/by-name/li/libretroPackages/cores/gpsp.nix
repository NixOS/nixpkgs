{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "gpsp";
  version = "0-unstable-2026-09-19";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "gpsp";
    rev = "5819380c2ffb0900219d700a382ee68c464ebb99";
    hash = "sha256-WAvYHs4YlGm5pTwFdbuZihewCnUlsrbABqV+9YnRNi8=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of gpSP to libretro";
    homepage = "https://github.com/libretro/gpsp";
    license = lib.licenses.gpl2Only;
  };
}
