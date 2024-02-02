{ callPackage }:
callPackage ./generic.nix {} rec {
  pname = "signal-desktop";
  dir = "Signal";
  version = "6.45.1";
  url = "https://updates.signal.org/desktop/apt/pool/s/signal-desktop/signal-desktop_${version}_amd64.deb";
  hash = "sha256-yDXtWm+HFzqLTsa7gxy8e7ObVn7lrRewoHMyDGlmZkY=";
}
