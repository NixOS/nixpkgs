{ callPackage, boost155, boost162, boost163, openssl_1_1_0, haskellPackages }:

rec {

  bitcoin  = callPackage ./bitcoin.nix { withGui = true; };
  bitcoind = callPackage ./bitcoin.nix { withGui = false; };

  bitcoin-abc  = callPackage ./bitcoin-abc.nix { withGui = true; };
  bitcoind-abc = callPackage ./bitcoin-abc.nix { withGui = false; };

  bitcoin-unlimited  = callPackage ./bitcoin-unlimited.nix { withGui = true; };
  bitcoind-unlimited = callPackage ./bitcoin-unlimited.nix { withGui = false; };

  bitcoin-classic  = callPackage ./bitcoin-classic.nix { withGui = true; };
  bitcoind-classic = callPackage ./bitcoin-classic.nix { withGui = false; };

  bitcoin-xt  = callPackage ./bitcoin-xt.nix { withGui = true; };
  bitcoind-xt = callPackage ./bitcoin-xt.nix { withGui = false; };

  btc1 = callPackage ./btc1.nix { withGui = true; };
  btc1d = callPackage ./btc1.nix { withGui = false; };

  dashpay = callPackage ./dashpay.nix { };

  dogecoin  = callPackage ./dogecoin.nix { withGui = true; };
  dogecoind = callPackage ./dogecoin.nix { withGui = false; };

  freicoin = callPackage ./freicoin.nix { boost = boost155; };
  go-ethereum = callPackage ./go-ethereum.nix { };
  go-ethereum-classic = callPackage ./go-ethereum-classic { };

  hivemind = callPackage ./hivemind.nix { withGui = true; };
  hivemindd = callPackage ./hivemind.nix { withGui = false; };

  litecoin  = callPackage ./litecoin.nix { withGui = true; };
  litecoind = callPackage ./litecoin.nix { withGui = false; };

  memorycoin  = callPackage ./memorycoin.nix { withGui = true; };
  memorycoind = callPackage ./memorycoin.nix { withGui = false; };

  namecoin  = callPackage ./namecoin.nix  { withGui = true; };
  namecoind = callPackage ./namecoin.nix { withGui = false; };

  ethabi = callPackage ./ethabi.nix { };
  ethrun = callPackage ./ethrun.nix { };
  seth = callPackage ./seth.nix { };
  dapp = callPackage ./dapp.nix { };

  hevm = (haskellPackages.callPackage ./hevm.nix {});

  primecoin  = callPackage ./primecoin.nix { withGui = true; };
  primecoind = callPackage ./primecoin.nix { withGui = false; };

  stellar-core = callPackage ./stellar-core.nix { };

  zcash = callPackage ./zcash {
    withGui = false;
    openssl = openssl_1_1_0;
    boost = boost163;
  };
}
