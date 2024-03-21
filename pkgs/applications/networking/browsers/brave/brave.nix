{ callPackage }:
callPackage ./generic.nix { } rec {
  pname = "brave";
  version = "1.64.109";
  url = "https://github.com/brave/brave-browser/releases/download/v${version}/brave-browser_${version}_amd64.deb";
  hash = "sha256-36igba0U3p8i7t91RxeG6PqlKYyHDDlj295ICcYmCNc=";
}
