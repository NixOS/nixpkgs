{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "prosystem";
  version = "0-unstable-2026-06-04";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "prosystem-libretro";
    rev = "363b6dfbd3e240762e022c2b4897b4fe55722be3";
    hash = "sha256-5KNxBCZq4BfBo5pF4tBzJNNyatrVQH4kmXmcyQcIPSY=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of ProSystem to libretro";
    homepage = "https://github.com/libretro/prosystem-libretro";
    license = lib.licenses.gpl2Only;
  };
}
