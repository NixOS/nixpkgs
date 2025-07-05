{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "dosbox-pure";
  version = "0-unstable-2025-06-16";

  src = fetchFromGitHub {
    owner = "schellingb";
    repo = "dosbox-pure";
    rev = "8c48d34327f5ffc44892899cf2567feaa9bbf72a";
    hash = "sha256-u5kxj4Sl7LpivEuNhTec8Z2u3Dw/X8xFDBQ++hQAtFc=";
  };

  hardeningDisable = [ "format" ];
  makefile = "Makefile";

  meta = {
    description = "Port of DOSBox to libretro aiming for simplicity and ease of use";
    homepage = "https://github.com/schellingb/dosbox-pure";
    license = lib.licenses.gpl2Only;
  };
}
