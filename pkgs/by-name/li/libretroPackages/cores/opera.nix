{
  lib,
  stdenv,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "opera";
  version = "0-unstable-2026-11-17";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "opera-libretro";
    rev = "e01f1dc83e325596b2d09e7f286b0219459433e6";
    hash = "sha256-LQPZWs2o7SnnO97+jyvAiQZhOM6kl41AD56XYtm5NQM=";
  };

  makefile = "Makefile";
  makeFlags = [ "CC_PREFIX=${stdenv.cc.targetPrefix}" ];

  meta = {
    description = "Opera is a port of 4DO/libfreedo to libretro";
    homepage = "https://github.com/libretro/libretro-o2em";
    license = lib.licenses.unfreeRedistributable;
  };
}
