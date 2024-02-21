{ callPackage }:
callPackage ./generic.nix {} rec {
  pname = "signal-desktop";
  dir = "Signal";
  version = "6.48.0";
  url = "https://updates.signal.org/desktop/apt/pool/s/signal-desktop/signal-desktop_${version}_amd64.deb";
  hash = "sha256-hQhMl3ArIZK+0u90uIw0mERv9z4aL1Nny9Qx/Cvsfl4=";
}
