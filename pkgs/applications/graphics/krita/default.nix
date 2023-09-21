{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "5.1.5";
  kde-channel = "stable";
  sha256 = "1lx4x4affkbh47b7w5qvahkkr4db0vcw6h24nykak6gpy2z5wxqw";
})
