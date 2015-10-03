{ callPackage, pkgs }:

rec {

  bitcoin  = callPackage ./bitcoin.nix { withGui = true; };
  bitcoind = callPackage ./bitcoin.nix { withGui = false; };

  bitcoin-xt  = callPackage ./bitcoin-xt.nix { withGui = true; };
  bitcoind-xt = callPackage ./bitcoin-xt.nix { withGui = false; };

  darkcoin  = callPackage ./darkcoin.nix { withGui = true; };
  darkcoind = callPackage ./darkcoin.nix { withGui = false; };

  dogecoin  = callPackage ./dogecoin.nix { withGui = true; };
  dogecoind = callPackage ./dogecoin.nix { withGui = false; };

  litecoin  = callPackage ./litecoin.nix { withGui = true; };
  litecoind = callPackage ./litecoin.nix { withGui = false; };

  memorycoin  = callPackage ./memorycoin.nix { withGui = true; };
  memorycoind = callPackage ./memorycoin.nix { withGui = false; };

  namecoin  = callPackage ./namecoin.nix  { inherit namecoind; };
  namecoind = callPackage ./namecoind.nix { };

  primecoin  = callPackage ./primecoin.nix { withGui = true; };
  primecoind = callPackage ./primecoin.nix { withGui = false; };

}
