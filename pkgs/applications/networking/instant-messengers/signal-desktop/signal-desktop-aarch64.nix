{ callPackage }:
callPackage ./generic.nix { } rec {
  pname = "signal-desktop";
  dir = "Signal";
  version = "7.19.0";
  url = "https://github.com/0mniteck/Signal-Desktop-Mobian/raw/${version}/builds/release/signal-desktop_${version}_arm64.deb";
  hash = "sha256-L5Wj1ofMR+QJezd4V6pAhkINLF6y9EB5VNFAIOZE5PU=";
}
