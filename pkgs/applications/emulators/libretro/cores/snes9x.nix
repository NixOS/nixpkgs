{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "snes9x";
  version = "0-unstable-2026-02-03";

  src = fetchFromGitHub {
    owner = "snes9xgit";
    repo = "snes9x";
    rev = "02f642cdadfaa8f9fa7ec674382d6c70a8b534d6";
    hash = "sha256-4BqWxchxdq8pbWw3Iql786Iu/OY5VMT1pF8wowI26h0=";
  };

  makefile = "Makefile";
  preBuild = "cd libretro";

  meta = {
    description = "Port of SNES9x git to libretro";
    homepage = "https://github.com/snes9xgit/snes9x";
    license = lib.licenses.unfreeRedistributable;
  };
}
