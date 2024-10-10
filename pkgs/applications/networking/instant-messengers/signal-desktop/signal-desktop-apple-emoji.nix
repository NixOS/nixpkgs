{ callPackage }:
callPackage ./generic.nix { } rec {
  pname = "signal-desktop";
  dir = "Signal";
  version = "7.26.0";
  url = "https://updates.signal.org/desktop/apt/pool/s/signal-desktop/signal-desktop_${version}_amd64.deb";
  hash = "sha256-lgPdXrp+i3TW35ttqm+8zPDz/RK0BTkErDaSmTA/3sk=";
  withUnfree = true;
}
