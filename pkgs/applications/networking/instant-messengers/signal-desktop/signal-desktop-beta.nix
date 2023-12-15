{ callPackage }:
callPackage ./generic.nix {} rec {
  pname = "signal-desktop-beta";
  dir = "Signal Beta";
  version = "6.40.0-beta.2";
  url = "https://updates.signal.org/desktop/apt/pool/s/signal-desktop-beta/signal-desktop-beta_${version}_amd64.deb";
  hash = "sha256-pfedkxbZ25DFgz+/N7ZEb9LwKrHuoMM+Zi+Tc21QPsg=";
}
