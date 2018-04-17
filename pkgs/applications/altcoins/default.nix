{ callPackage, boost155, boost165, openssl_1_1_0, haskellPackages, darwin, libsForQt5, miniupnpc_2, python3 }:

rec {

  aeon = callPackage ./aeon { };

  bitcoin  = libsForQt5.callPackage ./bitcoin.nix { miniupnpc = miniupnpc_2; withGui = true; };
  bitcoind = callPackage ./bitcoin.nix { miniupnpc = miniupnpc_2; withGui = false; };

  bitcoin-abc  = libsForQt5.callPackage ./bitcoin-abc.nix { boost = boost165; withGui = true; };
  bitcoind-abc = callPackage ./bitcoin-abc.nix { boost = boost165; withGui = false; };

  bitcoin-unlimited  = callPackage ./bitcoin-unlimited.nix { withGui = true; };
  bitcoind-unlimited = callPackage ./bitcoin-unlimited.nix { withGui = false; };

  bitcoin-classic  = libsForQt5.callPackage ./bitcoin-classic.nix { boost = boost165; withGui = true; };
  bitcoind-classic = callPackage ./bitcoin-classic.nix { boost = boost165; withGui = false; };

  bitcoin-xt  = callPackage ./bitcoin-xt.nix { boost = boost165; withGui = true; };
  bitcoind-xt = callPackage ./bitcoin-xt.nix { boost = boost165; withGui = false; };

  btc1 = callPackage ./btc1.nix { boost = boost165; withGui = true; };
  btc1d = callPackage ./btc1.nix { boost = boost165; withGui = false; };

  cryptop = python3.pkgs.callPackage ./cryptop { };

  dashpay = callPackage ./dashpay.nix { };

  dcrd = callPackage ./dcrd.nix { };
  dcrwallet = callPackage ./dcrwallet.nix { };

  dero = callPackage ./dero.nix { };

  dogecoin  = callPackage ./dogecoin.nix { boost = boost165; withGui = true; };
  dogecoind = callPackage ./dogecoin.nix { boost = boost165; withGui = false; };

  ethsign = callPackage ./ethsign { };

  freicoin = callPackage ./freicoin.nix { boost = boost155; };
  go-ethereum = callPackage ./go-ethereum.nix {
    inherit (darwin) libobjc;
    inherit (darwin.apple_sdk.frameworks) IOKit;
  };
  go-ethereum-classic = callPackage ./go-ethereum-classic { };

  litecoin  = callPackage ./litecoin.nix { withGui = true; };
  litecoind = callPackage ./litecoin.nix { withGui = false; };

  masari = callPackage ./masari.nix { };

  memorycoin  = callPackage ./memorycoin.nix { boost = boost165; withGui = true; };
  memorycoind = callPackage ./memorycoin.nix { boost = boost165; withGui = false; };

  namecoin  = callPackage ./namecoin.nix  { withGui = true; };
  namecoind = callPackage ./namecoin.nix { withGui = false; };

  ethabi = callPackage ./ethabi.nix { };
  ethrun = callPackage ./ethrun.nix { };
  seth = callPackage ./seth.nix { };
  dapp = callPackage ./dapp.nix { };

  hevm = (haskellPackages.callPackage ./hevm.nix {});

  stellar-core = callPackage ./stellar-core.nix { };

  sumokoin = callPackage ./sumokoin.nix { };

  zcash = callPackage ./zcash {
    withGui = false;
    openssl = openssl_1_1_0;
  };

  parity = callPackage ./parity { };
  parity-beta = callPackage ./parity/beta.nix { };
}
