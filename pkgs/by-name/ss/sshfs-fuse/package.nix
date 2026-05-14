{
  lib,
  callPackage,
  fetchpatch,
}:

let
  mkSSHFS = args: callPackage (import ./common.nix args) { };
in
mkSSHFS {
  version = "3.7.5";
  hash = "sha256-6SFjYYWx+p9tZQ670nbjbPtH/QvCAGCB0YwkaQbKIqA=";
  platforms = lib.platforms.darwin ++ lib.platforms.linux;
}
