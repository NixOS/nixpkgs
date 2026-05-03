{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore rec {
  core = "np2kai";
  version = "0-unstable-2026-04-01";

  src = fetchFromGitHub {
    owner = "AZO234";
    repo = "NP2kai";
    rev = "cbadd7572e0b13de0c0c011a86758ca4dc4a74ae";
    hash = "sha256-4p5SpXgGzfj2lc+0yAgwrRLDkYWrIkZi+XREQpNhdKA=";
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
