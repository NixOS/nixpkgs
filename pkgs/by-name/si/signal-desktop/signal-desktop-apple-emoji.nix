{ callPackage }:
callPackage ./generic.nix { } rec {
  pname = "signal-desktop";
  dir = "Signal";
  version = "7.29.0";
  url = "https://updates.signal.org/desktop/apt/pool/s/signal-desktop/signal-desktop_${version}_amd64.deb";
  hash = "sha256-MyoCPIrKidaPO20hEHekSWbC3FxROVPmu/KDwMgYypA=";
  withUnfree = true;
}
