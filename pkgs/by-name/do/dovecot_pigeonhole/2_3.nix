{
  callPackage,
  dovecot_2_3,
}@args:
callPackage ./generic.nix args {
  version = "0.5.21.1";
  hash = "sha256-A3fbKEtiByPeBgQxEV+y53keHfQyFBGvcYIB1pJcRpI=";

  dovecot = dovecot_2_3;
}
