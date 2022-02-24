{ mkDerivation, aeson, base, base16-bytestring, bech32, binary
, bytestring, cardano-api, cardano-binary, cardano-crypto-class
, cardano-crypto-wrapper, cardano-ledger-byron, cardano-ledger-core
, cardano-ledger-shelley, cardano-node, cardano-slotting
, compact-map, containers, cryptonite, fetchgit, filepath
, iohk-monitoring, lib, memory, mtl, optparse-applicative
, ouroboros-consensus, ouroboros-consensus-byron
, ouroboros-consensus-cardano, ouroboros-consensus-shelley
, ouroboros-network, sop-core, text, time, transformers
, transformers-except, typed-protocols, yaml
}:
mkDerivation {
  pname = "cardano-client-demo";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-node/";
    sha256 = "1hr00wqzmcyc3x0kp2hyw78rfmimf6z4zd4vv85b9zv3nqbjgrik";
    rev = "814df2c146f5d56f8c35a681fe75e85b905aed5d";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/cardano-client-demo; echo source root reset to $sourceRoot";
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    aeson base base16-bytestring bech32 binary bytestring cardano-api
    cardano-binary cardano-crypto-class cardano-crypto-wrapper
    cardano-ledger-byron cardano-ledger-core cardano-ledger-shelley
    cardano-node cardano-slotting compact-map containers cryptonite
    filepath iohk-monitoring memory mtl optparse-applicative
    ouroboros-consensus ouroboros-consensus-byron
    ouroboros-consensus-cardano ouroboros-consensus-shelley
    ouroboros-network sop-core text time transformers
    transformers-except typed-protocols yaml
  ];
  description = "A simple demo cardano-node client application";
  license = lib.licenses.asl20;
}
