{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2025-11-27";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "3609f054a65aea4b4cab5a87b2fdc876d911d244";
    hash = "sha256-S18J0S50/S/50rCmcGkwSLslnA1abvsX9HhtFVcQ7XM=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
