{
  lib,
  callPackage,
  fetchpatch,
  dovecot,
}:
callPackage ./generic.nix { } rec {
  url = "https://pigeonhole.dovecot.org/releases/${lib.versions.majorMinor dovecot.version}/dovecot-pigeonhole-${version}.tar.gz";
  version = "2.4.2";
  hash = "sha256-wvkM8qAVT5SELODYyvyB8oLQ+Y38O1HDt8I4XFMxb5c=";
  patches = [
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/dovecot/pigeonhole/pull/15.patch";
      sha256 = "sha256-BLBz9ZhOGEIIitnXG0uM6bZBRNnQBy4K2IJlh1+Un50=";
    })
  ];

  inherit dovecot;
}
