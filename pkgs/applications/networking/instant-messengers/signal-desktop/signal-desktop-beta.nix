{ callPackage }:
callPackage ./generic.nix {} rec {
  pname = "signal-desktop-beta";
  dir = "Signal Beta";
  version = "7.0.0-beta.2";
  url = "https://updates.signal.org/desktop/apt/pool/s/signal-desktop-beta/signal-desktop-beta_${version}_amd64.deb";
  hash = "sha256-yfa82JI/CKyQNT+oq0laupLyMIrq9Xs99M/xxgM9eQs=";
}
