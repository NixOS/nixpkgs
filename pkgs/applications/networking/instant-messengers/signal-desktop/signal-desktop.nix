{ callPackage }:
callPackage ./generic.nix {} rec {
  pname = "signal-desktop";
  dir = "Signal";
  version = "7.0.0";
  url = "https://updates.signal.org/desktop/apt/pool/s/signal-desktop/signal-desktop_${version}_amd64.deb";
  hash = "sha256-xwKisiOE2g+pg1P9mX6AlwYU1JWXIWSSygwauoU05E8=";
}
