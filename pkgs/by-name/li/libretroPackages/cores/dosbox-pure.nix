{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "dosbox-pure";
  version = "0-unstable-2026-09-15";

  src = fetchFromGitHub {
    owner = "schellingb";
    repo = "dosbox-pure";
    rev = "73e03aa145e0549ed4d5a20f8e65532714da33f5";
    hash = "sha256-0X15trbBZWxguG8ZfeSRtEx0cYYUkiNeDWOFad4KlQw=";
  };

  hardeningDisable = [ "format" ];
  makefile = "Makefile";

  meta = {
    description = "Port of DOSBox to libretro aiming for simplicity and ease of use";
    homepage = "https://github.com/schellingb/dosbox-pure";
    license = lib.licenses.gpl2Only;
  };
}
