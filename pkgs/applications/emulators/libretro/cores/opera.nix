{
  lib,
  stdenv,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "opera";
  version = "0-unstable-2026-06-19";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "opera-libretro";
    rev = "eb3a9162e99a71da221107aa58e7650fd076bbca";
    hash = "sha256-swFdGY8ScsQG/8E/JWzGRL80jdMVzsr1BJ+UAisSJ9g=";
  };

  makefile = "Makefile";
  makeFlags = [ "CC_PREFIX=${stdenv.cc.targetPrefix}" ];

  meta = {
    description = "Opera is a port of 4DO/libfreedo to libretro";
    homepage = "https://github.com/libretro/libretro-o2em";
    license = lib.licenses.unfreeRedistributable;
  };
}
