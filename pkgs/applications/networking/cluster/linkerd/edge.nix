{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "25.3.3";
  sha256 = "09a6sicbnp7cs89cwnzr8y25y4cdzcf87l06fvi8fvwkpd4dyqw6";
  vendorHash = "sha256-AmdOUpQVDbstNbejWh+WW2pyCP8/20nJ5v/Hbioa6J8=";
}
