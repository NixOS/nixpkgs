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
    buildVersion = "2124";
    dev = true;
    aarch64sha256 = "jYd22OPZnC6X2Ceuzz4ZiqqD1pFsmQsrihIqY3A+gAc=";
    x64sha256 = "3Tm9TH+kzTCElFLI44K00CXTuV98+uCswy4auXcY+YY=";
  } { };
}
