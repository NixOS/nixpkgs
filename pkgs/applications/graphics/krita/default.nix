{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "5.0.2";
  kde-channel = "stable";
  sha256 = "sha256-5nUfx+tQSXekiAo3brvTmVyH2tFUSGCE6COX5l1JnL8=";
})
