{ callPackage, ... }@args:

# Do not update this pinned version!
# Update ./package.nix instead or init an entirely new version based on this.
callPackage ./generic.nix args {
  rev = "85cc21e94af590a267c1c7a47020d9b420f8a033";
  revNum = "2233";
  version = "2025-04-28";
  sha256 = "sha256-+nKP2hBUKIqdNfDz1vGggXSdCuttOt0GwyGUQ3Z1ZHI=";
}
