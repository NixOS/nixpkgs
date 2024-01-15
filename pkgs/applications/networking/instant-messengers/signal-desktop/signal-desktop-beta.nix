{ callPackage }:
callPackage ./generic.nix {} rec {
  pname = "signal-desktop-beta";
  dir = "Signal Beta";
  version = "6.44.0-beta.1";
  url = "https://updates.signal.org/desktop/apt/pool/s/signal-desktop-beta/signal-desktop-beta_${version}_amd64.deb";
  hash = "sha256-SW/br1k7lO0hQngST0qV9Qol1hA9f1NZe86A5uyYhcI=";
}
