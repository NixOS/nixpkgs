{ callPackage }:
callPackage ./generic.nix { } rec {
  pname = "signal-desktop";
  dir = "Signal";
  version = "7.5.1";
  url = "https://updates.signal.org/desktop/signal-desktop-mac-arm64-${version}.dmg";
  hash = "sha256-q3+v5u//niA+ortlGMsNuVSJaIM72PF97NgG0yaGHlI=";
}
