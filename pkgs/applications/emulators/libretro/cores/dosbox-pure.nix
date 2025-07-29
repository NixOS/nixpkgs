{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "dosbox-pure";
  version = "0-unstable-2025-07-10";

  src = fetchFromGitHub {
    owner = "schellingb";
    repo = "dosbox-pure";
    rev = "92894e7bdb6304d23278dc77f8a9fa7212450f6e";
    hash = "sha256-uA/pm3DyT0VCyq85DzZGXjSGrKQ9uoEIfrs839ta97s=";
  };

  hardeningDisable = [ "format" ];
  makefile = "Makefile";

  meta = {
    description = "Port of DOSBox to libretro aiming for simplicity and ease of use";
    homepage = "https://github.com/schellingb/dosbox-pure";
    license = lib.licenses.gpl2Only;
  };
}
