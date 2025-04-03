{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "25.3.2";
  sha256 = "1l0sww0h3s1x9262rj801jk965p1c8bl92lns53yhkarv80cy03y";
  vendorHash = "sha256-9b98kz4jlkL6S4g/naOIiSazjo8twkk+PL4aXSWubfQ=";
}
