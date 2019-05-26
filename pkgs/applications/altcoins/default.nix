{ callPackage, boost155, boost165, openssl_1_1, haskellPackages, darwin, libsForQt5, libsForQt59, miniupnpc_2, python3, buildGo110Package }:

rec {

  aeon = callPackage ./aeon { };

  bitcoin  = libsForQt5.callPackage ./bitcoin.nix { miniupnpc = miniupnpc_2; withGui = true; };
  bitcoind = callPackage ./bitcoin.nix { miniupnpc = miniupnpc_2; withGui = false; };
  clightning = callPackage ./clightning.nix { };

  bitcoin-abc  = libsForQt5.callPackage ./bitcoin-abc.nix { boost = boost165; withGui = true; };
  bitcoind-abc = callPackage ./bitcoin-abc.nix { boost = boost165; withGui = false; };

  bitcoin-unlimited  = callPackage ./bitcoin-unlimited.nix {
    inherit (darwin.apple_sdk.frameworks) Foundation ApplicationServices AppKit;
    withGui = true;
  };
  bitcoind-unlimited = callPackage ./bitcoin-unlimited.nix {
    inherit (darwin.apple_sdk.frameworks) Foundation ApplicationServices AppKit;
    withGui = false;
  };

  bitcoin-classic  = libsForQt5.callPackage ./bitcoin-classic.nix { boost = boost165; withGui = true; };
  bitcoind-classic = callPackage ./bitcoin-classic.nix { boost = boost165; withGui = false; };

  bitcoin-xt  = callPackage ./bitcoin-xt.nix {
    inherit (darwin.apple_sdk.frameworks) Foundation ApplicationServices AppKit;
    boost = boost165; withGui = true;
  };
  bitcoind-xt = callPackage ./bitcoin-xt.nix {
    inherit (darwin.apple_sdk.frameworks) Foundation ApplicationServices AppKit;
    boost = boost165; withGui = false;
  };

  btc1 = callPackage ./btc1.nix {
    inherit (darwin.apple_sdk.frameworks) AppKit;
    boost = boost165;
  };
  btc1d = btc1.override { withGui = false; };

  cryptop = python3.pkgs.callPackage ./cryptop { };

  dashpay = callPackage ./dashpay.nix { };

  dcrd = callPackage ./dcrd.nix { };
  dcrwallet = callPackage ./dcrwallet.nix { };

  dero = callPackage ./dero.nix { boost = boost165; };

  dogecoin  = callPackage ./dogecoin.nix { boost = boost165; withGui = true; };
  dogecoind = callPackage ./dogecoin.nix { boost = boost165; withGui = false; };


  freicoin = callPackage ./freicoin.nix { boost = boost155; };
  go-ethereum = callPackage ./go-ethereum.nix {
    inherit (darwin) libobjc;
    inherit (darwin.apple_sdk.frameworks) IOKit;
  };
  go-ethereum-classic = callPackage ./go-ethereum-classic {
    buildGoPackage = buildGo110Package;
  };

  litecoin  = callPackage ./litecoin.nix {
    inherit (darwin.apple_sdk.frameworks) AppKit;
  };
  litecoind = litecoin.override { withGui = false; };

  masari = callPackage ./masari.nix { boost = boost165; };

  memorycoin  = callPackage ./memorycoin.nix { boost = boost165; withGui = true; };
  memorycoind = callPackage ./memorycoin.nix { boost = boost165; withGui = false; };

  mist = callPackage ./mist.nix { };

  namecoin  = callPackage ./namecoin.nix  { withGui = true; };
  namecoind = callPackage ./namecoin.nix { withGui = false; };

  pivx = libsForQt59.callPackage ./pivx.nix { withGui = true; };
  pivxd = callPackage ./pivx.nix { withGui = false; };

  ethabi = callPackage ./ethabi.nix { };

  stellar-core = callPackage ./stellar-core.nix { };

  sumokoin = callPackage ./sumokoin.nix { boost = boost165; };

  wownero = callPackage ./wownero.nix {
    inherit (darwin.apple_sdk.frameworks) CoreData IOKit PCSC;
  };

  zcash = callPackage ./zcash {
    withGui = false;
    openssl = openssl_1_1;
  };

  parity = callPackage ./parity { };
  parity-beta = callPackage ./parity/beta.nix { };
  parity-ui = callPackage ./parity-ui { };

  polkadot = callPackage ./polkadot { };

  particl-core = callPackage ./particl/particl-core.nix { miniupnpc = miniupnpc_2; };
}
