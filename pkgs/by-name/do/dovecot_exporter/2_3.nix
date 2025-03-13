{
  callPackage,
  dovecot_2_4,
}@args:
callPackage ./generic.nix args {
  dovecot = dovecot_2_4;
}
