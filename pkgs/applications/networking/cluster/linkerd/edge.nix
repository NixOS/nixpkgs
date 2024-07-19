{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "24.7.2";
  sha256 = "1kl1ik1w0j3m0qlfbdagzjgd67kabx358xaa2rn0clg8jk43nk3n";
  vendorHash = "sha256-/dYLPoPg3Oac4W1eLytJJiP7kzK4PTSjh8BRKjJAnU0=";
}
