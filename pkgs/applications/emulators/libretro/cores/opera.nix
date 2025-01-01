{
  lib,
  stdenv,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "opera";
  version = "0-unstable-2024-10-17";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "opera-libretro";
    rev = "67a29e60a4d194b675c9272b21b61eaa022f3ba3";
    hash = "sha256-8896EWNbzVyr3MS1jtWD3pLur7ZvAhhJmrwkW3ayzkU=";
  };

  makefile = "Makefile";
  makeFlags = [ "CC_PREFIX=${stdenv.cc.targetPrefix}" ];

  meta = {
    description = "Opera is a port of 4DO/libfreedo to libretro";
    homepage = "https://github.com/libretro/libretro-o2em";
    license = lib.licenses.unfreeRedistributable;
  };
}
