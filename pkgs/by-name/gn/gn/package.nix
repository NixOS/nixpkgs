{ callPackage, ... }@args:

callPackage ./generic.nix args {
  # Note: Please use the recommended version for Chromium stable, i.e. from
  # <nixpkgs>/pkgs/applications/networking/browsers/chromium/info.json
  rev = "6e8e0d6d4a151ab2ed9b4a35366e630c55888444";
  revNum = "2223"; # git describe $rev --match initial-commit | cut -d- -f3
  version = "2025-03-21";
  sha256 = "sha256-vDKMt23RMDI+KX6CmjfeOhRv2haf/mDOuHpWKnlODcg=";
}
