{ mkDerivation, aeson, aeson-pretty, array, attoparsec, base
, base16-bytestring, base58-bytestring, bech32, bytestring
, cardano-binary, cardano-crypto, cardano-crypto-class
, cardano-crypto-test, cardano-crypto-tests, cardano-crypto-wrapper
, cardano-data, cardano-ledger-alonzo, cardano-ledger-byron
, cardano-ledger-byron-test, cardano-ledger-core
, cardano-ledger-shelley, cardano-ledger-shelley-ma
, cardano-ledger-shelley-test, cardano-prelude
, cardano-protocol-tpraos, cardano-slotting, cborg, compact-map
, containers, contra-tracer, cryptonite, deepseq, directory
, fetchgit, filepath, formatting, hedgehog, hedgehog-extras
, iproute, lib, memory, network, nothunks, ouroboros-consensus
, ouroboros-consensus-byron, ouroboros-consensus-cardano
, ouroboros-consensus-protocol, ouroboros-consensus-shelley
, ouroboros-network, ouroboros-network-framework, parsec
, plutus-ledger-api, prettyprinter, QuickCheck, scientific
, small-steps, stm, strict-containers, tasty, tasty-hedgehog
, tasty-quickcheck, tasty-th, text, time, transformers
, transformers-except, typed-protocols, unordered-containers
, vector, yaml
}:
mkDerivation {
  pname = "cardano-api";
  version = "1.33.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-node/";
    sha256 = "1hr00wqzmcyc3x0kp2hyw78rfmimf6z4zd4vv85b9zv3nqbjgrik";
    rev = "814df2c146f5d56f8c35a681fe75e85b905aed5d";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/cardano-api; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    aeson aeson-pretty array attoparsec base base16-bytestring
    base58-bytestring bech32 bytestring cardano-binary cardano-crypto
    cardano-crypto-class cardano-crypto-test cardano-crypto-wrapper
    cardano-data cardano-ledger-alonzo cardano-ledger-byron
    cardano-ledger-byron-test cardano-ledger-core
    cardano-ledger-shelley cardano-ledger-shelley-ma cardano-prelude
    cardano-protocol-tpraos cardano-slotting cborg compact-map
    containers contra-tracer cryptonite deepseq directory filepath
    formatting hedgehog iproute memory network nothunks
    ouroboros-consensus ouroboros-consensus-byron
    ouroboros-consensus-cardano ouroboros-consensus-protocol
    ouroboros-consensus-shelley ouroboros-network
    ouroboros-network-framework parsec plutus-ledger-api prettyprinter
    scientific small-steps stm strict-containers text time transformers
    transformers-except typed-protocols unordered-containers vector
    yaml
  ];
  testHaskellDepends = [
    aeson base bytestring cardano-binary cardano-crypto
    cardano-crypto-class cardano-crypto-test cardano-crypto-tests
    cardano-ledger-core cardano-ledger-shelley
    cardano-ledger-shelley-test cardano-prelude cardano-slotting
    containers hedgehog hedgehog-extras ouroboros-consensus
    ouroboros-consensus-shelley QuickCheck tasty tasty-hedgehog
    tasty-quickcheck tasty-th time
  ];
  doHaddock = false;
  license = lib.licenses.asl20;
}
