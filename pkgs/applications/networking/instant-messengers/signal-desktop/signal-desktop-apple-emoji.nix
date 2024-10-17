{ callPackage }:
callPackage ./generic.nix { } rec {
  pname = "signal-desktop";
  dir = "Signal";
  version = "7.27.0";
  url = "https://updates.signal.org/desktop/apt/pool/s/signal-desktop/signal-desktop_${version}_amd64.deb";
  hash = "sha256-Ax1F90Xw4Nzer7IpcVPU3SueHNeJ/2y7J8jRL2rd4GE=";
  withUnfree = true;
}
