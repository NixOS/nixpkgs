{ callPackage }:
callPackage ./generic.nix { } rec {
  pname = "signal-desktop-beta";
  dir = "Signal Beta";
  version = "7.2.0-beta.1";
  url = "https://updates.signal.org/desktop/apt/pool/s/signal-desktop-beta/signal-desktop-beta_${version}_amd64.deb";
  hash = "sha256-ZCTCcNMrZwadAbs+1sf3A+S1FRjTCb1lYk0Vg5rxqXc=";
}
