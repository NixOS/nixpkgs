{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "25.7.1";
  sha256 = "1aijd3ymh95hqa896iidmffc1wn7fs318z023vvqk80rryqha5pa";
  vendorHash = "sha256-5/WtI24m260I4yy3PgIhh3c60anzlEjIBua41V9Gb1E=";
}
