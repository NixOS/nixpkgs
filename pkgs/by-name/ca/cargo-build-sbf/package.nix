{
  callPackage,
}:
# This file only re-exports the newest version by name, so that
# `pkgs.cargo-build-sbf` points at it.
(callPackage ./package-versions.nix { }).cargo-build-sbf_latest
