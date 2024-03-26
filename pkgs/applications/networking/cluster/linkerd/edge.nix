{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "24.3.4";
  sha256 = "0v9yjcy5wlkg3z9gl25s75j2irvn9jkgc542cz5w1gbc88i4b69v";
  vendorHash = "sha256-TmH3OhiSmUaKv2QPzMuzTq6wRTMu8LejE1y4Vy/tVRg=";
}
