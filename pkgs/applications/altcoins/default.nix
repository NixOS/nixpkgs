{ callPackage, boost155, openssl_1_1_0, haskellPackages, darwin, libsForQt5, miniupnpc_2, python3 }:

rec {

  aeon = callPackage ./aeon { };

  bitcoin  = libsForQt5.callPackage ./bitcoin.nix { miniupnpc = miniupnpc_2; withGui = true; };
  bitcoind = callPackage ./bitcoin.nix { miniupnpc = miniupnpc_2; withGui = false; };

  bitcoin-abc  = libsForQt5.callPackage ./bitcoin-abc.nix { withGui = true; };
  bitcoind-abc = callPackage ./bitcoin-abc.nix { withGui = false; };

  bitcoin-unlimited  = callPackage ./bitcoin-unlimited.nix { withGui = true; };
  bitcoind-unlimited = callPackage ./bitcoin-unlimited.nix { withGui = false; };

  bitcoin-classic  = libsForQt5.callPackage ./bitcoin-classic.nix { withGui = true; };
  bitcoind-classic = callPackage ./bitcoin-classic.nix { withGui = false; };

  bitcoin-xt  = callPackage ./bitcoin-xt.nix { withGui = true; };
  bitcoind-xt = callPackage ./bitcoin-xt.nix { withGui = false; };

  btc1 = callPackage ./btc1.nix { withGui = true; };
  btc1d = callPackage ./btc1.nix { withGui = false; };

  cryptop = python3.pkgs.callPackage ./cryptop { };

  dashpay = callPackage ./dashpay.nix { };

  dero = callPackage ./dero.nix { };

  dogecoin  = callPackage ./dogecoin.nix { withGui = true; };
  dogecoind = callPackage ./dogecoin.nix { withGui = false; };

  ethsign = callPackage ./ethsign { };

  freicoin = callPackage ./freicoin.nix { boost = boost155; };
  go-ethereum = callPackage ./go-ethereum.nix {
    inherit (darwin) libobjc;
    inherit (darwin.apple_sdk.frameworks) IOKit;
  };
  go-ethereum-classic = callPackage ./go-ethereum-classic { };

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

  sumokoin = callPackage ./sumokoin.nix { };

  zcash = callPackage ./zcash {
    withGui = false;
    openssl = openssl_1_1_0;
  };
}
