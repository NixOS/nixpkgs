{ callPackage }:
callPackage ./generic.nix {} rec {
  pname = "signal-desktop";
  dir = "Signal";
  version = "6.45.0";
  url = "https://updates.signal.org/desktop/signal-desktop-mac-x64-${version}.dmg";
  hash = "sha256-M8DPh7/aenqFX4vvQaSAY0QXfTXwejvHd5gh0KxY4eI=";
}
