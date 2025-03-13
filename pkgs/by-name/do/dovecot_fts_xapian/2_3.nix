{
  callPackage,
  dovecot_2_3,
}@args:
callPackage ./generic.nix args {
  dovecot = dovecot_2_3;
}
