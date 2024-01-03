{ callPackage }:
callPackage ./generic.nix {} rec {
  pname = "signal-desktop";
  dir = "Signal";
  version = "6.42.1";
  url = "https://updates.signal.org/desktop/apt/pool/s/signal-desktop/signal-desktop_${version}_amd64.deb";
  hash = "sha256-6X2+kvqijNq2KsWQ9o4+y2ACDfAd6eeNqVqpDOoqZgs=";
}
