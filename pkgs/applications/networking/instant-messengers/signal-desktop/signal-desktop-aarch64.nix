{ callPackage }:
callPackage ./generic.nix { } rec {
  pname = "signal-desktop";
  dir = "Signal";
  version = "7.5.1";
  url = "https://github.com/0mniteck/Signal-Desktop-Mobian/raw/${version}/builds/release/signal-desktop_${version}_arm64.deb";
  hash = "sha256-X7B7eQQXTZ+ADLrrLI9XUsl7rHO9akMeW2zAgduXfLY=";
}
