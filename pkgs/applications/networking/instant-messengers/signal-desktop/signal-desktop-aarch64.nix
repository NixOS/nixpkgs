{ callPackage }:
callPackage ./generic.nix { } rec {
  pname = "signal-desktop";
  dir = "Signal";
  version = "6.40.0";
  url = "https://github.com/0mniteck/Signal-Desktop-Mobian/raw/${version}/builds/release/signal-desktop_${version}_arm64.deb";
  hash = "sha256-3Pi0c+CGcJR1M4ll51m+B5PmGIcIjjlc0qa9b8rkMeU=";
}
