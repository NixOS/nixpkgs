{ callPackage }:

rec {

  geth = callPackage ./geth.nix {};

  mist = callPackage ./mist.nix {};

}
