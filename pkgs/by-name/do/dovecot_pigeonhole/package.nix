{
  lib,
  callPackage,
  dovecot,
}:
callPackage ./generic.nix { } rec {
  url = "https://pigeonhole.dovecot.org/releases/${lib.versions.majorMinor dovecot.version}/dovecot-pigeonhole-${version}.tar.gz";
  version = "2.4.0";
  hash = "sha256-DtCK4WOsOalEcgD7tC17OwXTXpHZmBjdD0r9etHbx1M=";

  inherit dovecot;
}
