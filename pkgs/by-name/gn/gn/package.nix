{ callPackage, ... }@args:

callPackage ./generic.nix args {
  # Note: Please use the recommended version for Chromium stable, i.e. from
  # <nixpkgs>/pkgs/applications/networking/browsers/chromium/info.json
  rev = "85cc21e94af590a267c1c7a47020d9b420f8a033";
  revNum = "2233"; # git describe $rev --match initial-commit | cut -d- -f3
  version = "2025-04-28";
  sha256 = "sha256-+nKP2hBUKIqdNfDz1vGggXSdCuttOt0GwyGUQ3Z1ZHI=";
}
