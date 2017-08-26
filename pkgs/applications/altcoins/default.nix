{ callPackage, pkgs }:

rec {

  bitcoin  = callPackage ./bitcoin.nix { withGui = true; };
  bitcoind = callPackage ./bitcoin.nix { withGui = false; };

  bitcoin-unlimited  = callPackage ./bitcoin-unlimited.nix { withGui = true; };
  bitcoind-unlimited = callPackage ./bitcoin-unlimited.nix { withGui = false; };

  bitcoin-classic  = callPackage ./bitcoin-classic.nix { withGui = true; };
  bitcoind-classic = callPackage ./bitcoin-classic.nix { withGui = false; };

  bitcoin-xt  = callPackage ./bitcoin-xt.nix { withGui = true; };
  bitcoind-xt = callPackage ./bitcoin-xt.nix { withGui = false; };

  dashpay = callPackage ./dashpay.nix { };

  dogecoin  = callPackage ./dogecoin.nix { withGui = true; };
  dogecoind = callPackage ./dogecoin.nix { withGui = false; };

  freicoin = callPackage ./freicoin.nix { boost = pkgs.boost155; };
  go-ethereum = callPackage ./go-ethereum.nix { };
  go-ethereum-classic = callPackage ./go-ethereum-classic { };

  hivemind = callPackage ./hivemind.nix { withGui = true; };
  hivemindd = callPackage ./hivemind.nix { withGui = false; };

  litecoin  = callPackage ./litecoin.nix { withGui = true; };
  litecoind = callPackage ./litecoin.nix { withGui = false; };

  memorycoin  = callPackage ./memorycoin.nix { withGui = true; };
  memorycoind = callPackage ./memorycoin.nix { withGui = false; };

  namecoin  = callPackage ./namecoin.nix  { inherit namecoind; };
  namecoind = callPackage ./namecoind.nix { };

  ethabi = callPackage ./ethabi.nix { };
  ethrun = callPackage ./ethrun.nix { };
  seth = callPackage ./seth.nix { };
  dapp = callPackage ./dapp.nix { };

  hsevm = (pkgs.haskellPackages.callPackage ./hsevm.nix {});

  primecoin  = callPackage ./primecoin.nix { withGui = true; };
  primecoind = callPackage ./primecoin.nix { withGui = false; };

  stellar-core = callPackage ./stellar-core.nix { };

  zcash = callPackage ./zcash {
    withGui = false;
    openssl = pkgs.openssl_1_1_0;
    boost = pkgs.boost163;
  };
}
