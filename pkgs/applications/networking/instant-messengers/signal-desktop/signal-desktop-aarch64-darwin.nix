{ callPackage }:
callPackage ./generic.nix {} rec {
  pname = "signal-desktop";
  dir = "Signal";
  version = "6.45.0";
  url = "https://updates.signal.org/desktop/signal-desktop-mac-arm64-${version}.dmg";
  hash = "sha256-FWBG5bBPUIJiFuZ84LeKb2qS2gNO9Ig4vtqNIrqhNe0=";
}
