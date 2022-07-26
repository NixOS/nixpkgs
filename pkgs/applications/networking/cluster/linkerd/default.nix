{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "stable";
  version = "2.11.2";
  sha256 = "sha256-6FlOHnOmqZ2jqx9qFMPA5jkxBaNqzeCwsepwXR1Imss=";
  vendorSha256 = "sha256-wM5qIjabg9ICJcLi8QV9P4G4E7Rn3ctVCqdm2GO8RyU=";
}
