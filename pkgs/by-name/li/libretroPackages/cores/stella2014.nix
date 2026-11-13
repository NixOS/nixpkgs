{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "stella2014";
  version = "0-unstable-2026-09-04";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "stella2014-libretro";
    rev = "7d1361e407e63f29e52892655069e5fb4096e691";
    hash = "sha256-jIDuexx2SgQbqXsSl1EDH2ji65JKXFDX6AevEf3QwJQ=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of Stella ~2014 to libretro";
    homepage = "https://github.com/libretro/stella2014-libretro";
    license = lib.licenses.gpl2Only;
  };
}
