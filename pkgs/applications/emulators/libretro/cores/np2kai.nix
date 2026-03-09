{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore rec {
  core = "np2kai";
  version = "0-unstable-2026-03-08";

  src = fetchFromGitHub {
    owner = "AZO234";
    repo = "NP2kai";
    rev = "36df8cd8b1397ec372d9a6f2f30d892b6f30e2b8";
    hash = "sha256-JHKZ/FwxF9CQ6piGpnAxLqISUC4lz89jRWDIjxtxBQs=";
    fetchSubmodules = true;
  };

  makeFlags = [
    # See https://github.com/AZO234/NP2kai/tags
    "NP2KAI_VERSION=rev.22"
    "NP2KAI_HASH=${builtins.substring 0 7 src.rev}"
  ];

  # Fix build with GCC 14
  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=incompatible-pointer-types"
    "-Wno-error=int-conversion"
  ];

  preBuild = "cd sdl";

  meta = {
    description = "Neko Project II kai libretro port";
    homepage = "https://github.com/AZO234/NP2kai";
    license = lib.licenses.mit;
  };
}
