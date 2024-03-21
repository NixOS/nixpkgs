{ callPackage }:
callPackage ./generic.nix { } rec {
  pname = "brave";
  version = "1.63.174";
  url = "https://github.com/brave/brave-browser/releases/download/v${version}/brave-browser_${version}_amd64.deb";
  hash = "sha256-coy1xwoon0agp5dldvuafhpfvgubbclagruq5pfgtjk=";
}
