{
  lib,
  callPackage,
  dovecot,
}:
callPackage ./generic.nix { } rec {
  url = "https://pigeonhole.dovecot.org/releases/${lib.versions.majorMinor dovecot.version}/dovecot-pigeonhole-${version}.tar.gz";
  version = "2.4.2";
  hash = "sha256-wvkM8qAVT5SELODYyvyB8oLQ+Y38O1HDt8I4XFMxb5c=";

  inherit dovecot;
}
