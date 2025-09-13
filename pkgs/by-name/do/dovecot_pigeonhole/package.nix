{
  lib,
  callPackage,
  fetchpatch,
  dovecot,
}:
callPackage ./generic.nix { } rec {
  url = "https://pigeonhole.dovecot.org/releases/${lib.versions.majorMinor dovecot.version}/dovecot-pigeonhole-${version}.tar.gz";
  version = "2.4.0";
  hash = "sha256-DtCK4WOsOalEcgD7tC17OwXTXpHZmBjdD0r9etHbx1M=";
  patches = [
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/dovecot/pigeonhole/pull/15.patch";
      sha256 = "sha256-BLBz9ZhOGEIIitnXG0uM6bZBRNnQBy4K2IJlh1+Un50=";
    })
  ];

  inherit dovecot;
}
