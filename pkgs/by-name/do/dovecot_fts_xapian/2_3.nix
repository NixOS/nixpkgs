{
  callPackage,
  dovecot_2_3,
}:
callPackage ./generic.nix { } {
  dovecot = dovecot_2_3;
}
