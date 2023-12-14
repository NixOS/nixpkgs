{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "23.11.4";
  sha256 = "0j6yzjd2rnm6vzn2fky83pw3v943n3chhnr7a302rnafprlbmmp4";
  vendorHash = "sha256-1s2vj9GSNe4j9TtIo69uakrg8PnBHNchlApryBeHmKs=";
}
