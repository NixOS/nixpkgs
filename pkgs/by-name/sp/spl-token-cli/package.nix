{
  callPackage,
}:
# pinned by agave v4.1+ are provided; the newest is exposed by name so that
# `pkgs.spl-token-cli` points at it.
(callPackage ./package-versions.nix { }).spl-token-cli_latest
