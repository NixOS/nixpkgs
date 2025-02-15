{ callPackage }:
callPackage ./generic.nix { } rec {
  pname = "signal-desktop";
  dir = "Signal";
  version = "7.42.0";
  url = "https://updates.signal.org/desktop/apt/pool/s/signal-desktop/signal-desktop_${version}_amd64.deb";
  hash = "sha256-LuqE2SE6RurcwU5fl3uOJNtNZTBTR+xO2W6z98Gv53A=";
}
