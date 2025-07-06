{
  callPackage,
  dovecot,
}:
callPackage ./generic.nix { } {
  inherit dovecot;
}
