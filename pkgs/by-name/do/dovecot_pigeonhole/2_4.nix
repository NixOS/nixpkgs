{
  callPackage,
  dovecot_2_4,
}@args:
callPackage ./generic.nix args {
  version = "2.4.0";
  hash = "sha256-DtCK4WOsOalEcgD7tC17OwXTXpHZmBjdD0r9etHbx1M=";

  dovecot = dovecot_2_4;
}
