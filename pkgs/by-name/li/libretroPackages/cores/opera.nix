{
  lib,
  stdenv,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "opera";
  version = "0-unstable-2026-10-28";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "opera-libretro";
    rev = "54fe4f3754e9b69c83ff50b5def5d6c60fef06ce";
    hash = "sha256-FpzDTvKN10FRHW32ds3/qRUhexk2nsGjyw0f8sbc+kE=";
  };

  makefile = "Makefile";
  makeFlags = [ "CC_PREFIX=${stdenv.cc.targetPrefix}" ];

  meta = {
    description = "Opera is a port of 4DO/libfreedo to libretro";
    homepage = "https://github.com/libretro/libretro-o2em";
    license = lib.licenses.unfreeRedistributable;
  };
}
