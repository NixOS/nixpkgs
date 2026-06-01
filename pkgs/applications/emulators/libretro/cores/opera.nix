{
  lib,
  stdenv,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "opera";
  version = "0-unstable-2026-05-30";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "opera-libretro";
    rev = "d0a3b910f8bef6b8d48fb5eec4ad72ea5f022394";
    hash = "sha256-OH9gkbMC4PJnpboiYrKV+XkQqq5ldq5tneyVJHfDzsM=";
  };

  makefile = "Makefile";
  makeFlags = [ "CC_PREFIX=${stdenv.cc.targetPrefix}" ];

  meta = {
    description = "Opera is a port of 4DO/libfreedo to libretro";
    homepage = "https://github.com/libretro/libretro-o2em";
    license = lib.licenses.unfreeRedistributable;
  };
}
