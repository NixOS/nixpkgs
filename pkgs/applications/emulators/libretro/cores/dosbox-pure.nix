{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "dosbox-pure";
  version = "0-unstable-2025-09-28";

  src = fetchFromGitHub {
    owner = "schellingb";
    repo = "dosbox-pure";
    rev = "150a8e02ec53bfd5fc571587dab902c075f9e291";
    hash = "sha256-3l566sa5sCjeppUD06chpTZ21CnfEzdRpZKM7jxkS2M=";
  };

  hardeningDisable = [ "format" ];
  makefile = "Makefile";

  meta = {
    description = "Port of DOSBox to libretro aiming for simplicity and ease of use";
    homepage = "https://github.com/schellingb/dosbox-pure";
    license = lib.licenses.gpl2Only;
  };
}
