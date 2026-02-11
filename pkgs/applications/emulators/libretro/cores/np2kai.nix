{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore rec {
  core = "np2kai";
  version = "0-unstable-2026-02-01";

  src = fetchFromGitHub {
    owner = "AZO234";
    repo = "NP2kai";
    rev = "15676585b9a370e874ea9309252bd8236df3f642";
    hash = "sha256-Zaay3JYCjv1eohNTC/9AYD0ZrvNaz9X4A4D6CkB/n+4=";
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
