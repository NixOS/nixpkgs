{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "dosbox-pure";
  version = "0-unstable-2025-02-18";

  src = fetchFromGitHub {
    owner = "schellingb";
    repo = "dosbox-pure";
    rev = "f642201d1f11ef9f4f013ad5a5afdf4f1a9b4ef0";
    hash = "sha256-8E8gNS1k0bh5WXBUjuRRXcA8lHyP6dNZS1QkySoBqG0=";
  };

  hardeningDisable = [ "format" ];
  makefile = "Makefile";

  meta = {
    description = "Port of DOSBox to libretro aiming for simplicity and ease of use";
    homepage = "https://github.com/schellingb/dosbox-pure";
    license = lib.licenses.gpl2Only;
  };
}
