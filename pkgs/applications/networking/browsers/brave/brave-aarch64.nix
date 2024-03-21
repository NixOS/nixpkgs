{ callPackage }:
callPackage ./generic.nix { } rec {
  pname = "brave";
  version = "1.63.174";
  url = "https://github.com/brave/brave-browser/releases/download/v${version}/brave-browser_${version}_arm64.deb";
  hash = "sha256-yJXPe1j0+W84O1OymaIDX95x0XPwlRfst8HfR5d1bG8=";
}
