{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "5.1.4";
  kde-channel = "stable";
  sha256 = "sha256-wisCCGJZbrL92RHhsXnbvOewgb4RFFei6sr2rhzKLcs=";
})
