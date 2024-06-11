{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "24.5.5";
  sha256 = "0lgpqx672ics998830y8qklchdmbj272xfbs5r414hqlznbbi8w1";
  vendorHash = "sha256-PV0HbsIcO6FjdczCWJgR6X5THUREDht2R4NJ7HxkBNw=";
}
