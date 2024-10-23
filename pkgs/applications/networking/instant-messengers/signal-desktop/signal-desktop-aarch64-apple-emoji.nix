{ callPackage }:
callPackage ./generic.nix { } rec {
  pname = "signal-desktop";
  dir = "Signal";
  version = "7.23.0";
  url = "https://github.com/0mniteck/Signal-Desktop-Mobian/raw/${version}/builds/release/signal-desktop_${version}_arm64.deb";
  hash = "sha256-JA2uP1CZzKjLJyV0Sfjh3qGMsIvuvCufTc5l98mTe04=";
  withUnfree = true;
}
