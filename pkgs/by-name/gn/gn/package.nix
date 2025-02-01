{ callPackage, ... }@args:

callPackage ./generic.nix args {
  # Note: Please use the recommended version for Chromium stabe, i.e. from
  # <nixpkgs>/pkgs/applications/networking/browsers/chromium/upstream-info.nix
  rev = "df98b86690c83b81aedc909ded18857296406159";
  revNum = "2168"; # git describe $rev --match initial-commit | cut -d- -f3
  version = "2024-05-13";
  sha256 = "sha256-mNoQeHSSM+rhR0UHrpbyzLJC9vFqfxK1SD0X8GiRsqw=";
}
