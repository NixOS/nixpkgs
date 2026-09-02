{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore rec {
  core = "np2kai";
  version = "0-unstable-2026-08-24";

  src = fetchFromGitHub {
    owner = "AZO234";
    repo = "NP2kai";
    rev = "d1a40352e24f943a91966c48211c92e6eb07f3a5";
    hash = "sha256-3uAXxdaymzDY98eUqZij7YdCjfE5ob9Ug1dNwUUHxIo=";
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
