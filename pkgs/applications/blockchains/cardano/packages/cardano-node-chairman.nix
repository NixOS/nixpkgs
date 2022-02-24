{ mkDerivation, base, bytestring, cardano-api, cardano-cli
, cardano-config, cardano-ledger-byron, cardano-node
, cardano-prelude, cardano-testnet, containers, contra-tracer
, fetchgit, filepath, hedgehog, hedgehog-extras, io-classes, lib
, network, network-mux, optparse-applicative-fork
, ouroboros-consensus, ouroboros-network
, ouroboros-network-framework, process, random, resourcet
, strict-stm, tasty, tasty-hedgehog, text, time, unliftio
}:
mkDerivation {
  pname = "cardano-node-chairman";
  version = "1.33.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-node/";
    sha256 = "1hr00wqzmcyc3x0kp2hyw78rfmimf6z4zd4vv85b9zv3nqbjgrik";
    rev = "814df2c146f5d56f8c35a681fe75e85b905aed5d";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/cardano-node-chairman; echo source root reset to $sourceRoot";
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    base bytestring cardano-api cardano-config cardano-ledger-byron
    cardano-node cardano-prelude containers contra-tracer io-classes
    network-mux optparse-applicative-fork ouroboros-consensus
    ouroboros-network ouroboros-network-framework strict-stm text time
  ];
  testHaskellDepends = [
    base cardano-testnet filepath hedgehog hedgehog-extras network
    process random resourcet tasty tasty-hedgehog unliftio
  ];
  testToolDepends = [ cardano-cli cardano-node ];
  license = lib.licenses.asl20;
}
