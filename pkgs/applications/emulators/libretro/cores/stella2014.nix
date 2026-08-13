{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "stella2014";
  version = "0-unstable-2026-07-06";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "stella2014-libretro";
    rev = "4a7da82595d27b8df7af1ecb467a64b642a41bc9";
    hash = "sha256-uwtYNo6hUR6u2OicFYcbfgCGNlpDfIOF7Q5bNuJ/uMM=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of Stella ~2014 to libretro";
    homepage = "https://github.com/libretro/stella2014-libretro";
    license = lib.licenses.gpl2Only;
  };
}
