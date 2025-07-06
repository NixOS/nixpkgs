{
  lib,
  callPackage,
  dovecot_2_3,
}:
callPackage ./generic.nix { } rec {
  url = "https://pigeonhole.dovecot.org/releases/${lib.versions.majorMinor dovecot.version}/dovecot-${lib.versions.majorMinor dovecot.version}-pigeonhole-${version}.tar.gz";
  version = "0.5.21.1";
  hash = "sha256-A3fbKEtiByPeBgQxEV+y53keHfQyFBGvcYIB1pJcRpI=";

  dovecot = dovecot_2_3;
}
