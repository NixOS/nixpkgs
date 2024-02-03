{ callPackage }:
callPackage ./generic.nix { } rec {
  pname = "signal-desktop";
  dir = "Signal";
  version = "7.5.1";
  url = "https://updates.signal.org/desktop/signal-desktop-mac-x64-${version}.dmg";
  hash = "sha256-3GFGiMWYQSQX1EQPYPWikr+0iAo36KZUjsTGkR9MQdA=";
}
