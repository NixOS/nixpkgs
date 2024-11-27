{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore rec {
  core = "np2kai";
  version = "0-unstable-2024-11-03";

  src = fetchFromGitHub {
    owner = "AZO234";
    repo = "NP2kai";
    rev = "4b109eaac4f79b04065ff5025319fce51537e04d";
    hash = "sha256-tRFvK8d5Y/umy/b1BKN85ZSaDWyK95hII4RVng7A5uU=";
    fetchSubmodules = true;
  };

  makeFlags = [
    # See https://github.com/AZO234/NP2kai/tags
    "NP2KAI_VERSION=rev.22"
    "NP2KAI_HASH=${builtins.substring 0 7 src.rev}"
  ];

  preBuild = "cd sdl";

  meta = {
    description = "Neko Project II kai libretro port";
    homepage = "https://github.com/AZO234/NP2kai";
    license = lib.licenses.mit;
  };
}
