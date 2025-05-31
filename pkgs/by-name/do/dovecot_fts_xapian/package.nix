{
  callPackage,
  dovecot,
}@args:
callPackage ./generic.nix args {
  inherit dovecot;
}
