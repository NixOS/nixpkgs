{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore rec {
  core = "np2kai";
  version = "0-unstable-2026-01-19";

  src = fetchFromGitHub {
    owner = "AZO234";
    repo = "NP2kai";
    rev = "e2138c44ea539b36b2d1fc17b70c14fcedfd9784";
    hash = "sha256-59u8UWk2KNtZNAUcMql0BaCY+VtDs7GssrQRbXbqB3c=";
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
