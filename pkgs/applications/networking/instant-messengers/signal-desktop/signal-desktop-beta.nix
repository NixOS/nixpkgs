{ callPackage }:
callPackage ./generic.nix {} rec {
  pname = "signal-desktop-beta";
  dir = "Signal Beta";
  version = "6.43.0-beta.1";
  url = "https://updates.signal.org/desktop/apt/pool/s/signal-desktop-beta/signal-desktop-beta_${version}_amd64.deb";
  hash = "sha256-7UlfpOWAalJjZjAJLa2CL3HdR2LFlE1/5sdec5Sj/tg=";
}
