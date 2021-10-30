{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "4.4.8";
  kde-channel = "stable";
  sha256 = "1y0d8gnxfdg5nfwk8dgx8fc2bwskvnys049napb1a9fr25bqmimw";
})
