{
  lib,
  stdenv,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "opera";
  version = "0-unstable-2026-11-09";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "opera-libretro";
    rev = "595fd1db7d5bf0d3ca63d2292854d587ddcfa94b";
    hash = "sha256-zC1ynUdY6y0eTBFEcm3AxGQoajU3/nFbjXp2FWyZjUU=";
  };

  makefile = "Makefile";
  makeFlags = [ "CC_PREFIX=${stdenv.cc.targetPrefix}" ];

  meta = {
    description = "Opera is a port of 4DO/libfreedo to libretro";
    homepage = "https://github.com/libretro/libretro-o2em";
    license = lib.licenses.unfreeRedistributable;
  };
}
