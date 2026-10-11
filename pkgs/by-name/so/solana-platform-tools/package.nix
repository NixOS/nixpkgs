{
  callPackage,
}:

# This file only re-exports the newest version by name, so that
# `pkgs.solana-platform-tools` points at it.
(callPackage ./package-versions.nix { }).solana-platform-tools_latest
