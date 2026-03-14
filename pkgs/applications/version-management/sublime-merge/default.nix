{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in
{
  sublime-merge = common {
    buildVersion = "2123";
    aarch64sha256 = "9ceHfTutGJAZlIwRUXJvpli7LtZFuz6vuDgIi7i9+kM=";
    x64sha256 = "HxKKwc4dOX1ADPl0axn5bDr21yG5FsrrzMyK95p6sy4=";
  } { };

  sublime-merge-dev = common {
    buildVersion = "2122";
    dev = true;
    aarch64sha256 = "SfmEaBbJCiLXm8XZu8tPD4Sx7Se2S2Zxt+fbZwi5R3w=";
    x64sha256 = "5o4Vn/yfTU6anfPofNZBNaBCuXpPwJEQgFcPyExUxeo=";
  } { };
}
