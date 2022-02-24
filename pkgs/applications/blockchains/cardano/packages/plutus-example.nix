{ mkDerivation, aeson, base, bytestring, cardano-api, cardano-cli
, cardano-ledger-alonzo, cardano-ledger-core
, cardano-ledger-shelley, cardano-prelude, cardano-slotting
, containers, directory, fetchgit, filepath, hedgehog, lib
, optparse-applicative, ouroboros-consensus, ouroboros-network
, plutus-ledger, plutus-ledger-api, plutus-tx, plutus-tx-plugin
, serialise, strict-containers, transformers, transformers-except
}:
mkDerivation {
  pname = "plutus-example";
  version = "1.33.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-node/";
    sha256 = "1hr00wqzmcyc3x0kp2hyw78rfmimf6z4zd4vv85b9zv3nqbjgrik";
    rev = "814df2c146f5d56f8c35a681fe75e85b905aed5d";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/plutus-example; echo source root reset to $sourceRoot";
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson base bytestring cardano-api cardano-cli cardano-ledger-alonzo
    cardano-ledger-core cardano-slotting containers ouroboros-consensus
    ouroboros-network plutus-ledger plutus-ledger-api plutus-tx
    plutus-tx-plugin serialise strict-containers transformers
    transformers-except
  ];
  executableHaskellDepends = [
    base bytestring cardano-api directory filepath optparse-applicative
    transformers
  ];
  testHaskellDepends = [
    aeson base cardano-api cardano-ledger-alonzo cardano-ledger-core
    cardano-ledger-shelley cardano-prelude containers hedgehog
    plutus-ledger plutus-ledger-api
  ];
  license = lib.licenses.asl20;
}
