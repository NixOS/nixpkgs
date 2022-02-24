{ mkDerivation, aeson, async, base, base16-bytestring, bytestring
, cardano-api, cardano-config, cardano-crypto-class
, cardano-crypto-wrapper, cardano-ledger-alonzo
, cardano-ledger-byron, cardano-ledger-core, cardano-ledger-shelley
, cardano-ledger-shelley-ma, cardano-prelude
, cardano-protocol-tpraos, cardano-slotting, cborg, containers
, contra-tracer, deepseq, directory, dns, ekg, ekg-core, fetchgit
, filepath, generic-data, hedgehog, hedgehog-corpus, hostname
, io-classes, iohk-monitoring, iproute, lib
, lobemo-backend-aggregation, lobemo-backend-ekg
, lobemo-backend-monitoring, lobemo-backend-trace-forwarder
, lobemo-scribe-systemd, network, network-mux, nothunks
, optparse-applicative-fork, ouroboros-consensus
, ouroboros-consensus-byron, ouroboros-consensus-cardano
, ouroboros-consensus-protocol, ouroboros-consensus-shelley
, ouroboros-network, ouroboros-network-framework, process, psqueues
, safe-exceptions, scientific, small-steps, stm, strict-stm
, systemd, text, time, tracer-transformers, transformers
, transformers-except, typed-protocols, unix, unordered-containers
, yaml
}:
mkDerivation {
  pname = "cardano-node";
  version = "1.33.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-node/";
    sha256 = "1hr00wqzmcyc3x0kp2hyw78rfmimf6z4zd4vv85b9zv3nqbjgrik";
    rev = "814df2c146f5d56f8c35a681fe75e85b905aed5d";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/cardano-node; echo source root reset to $sourceRoot";
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson async base base16-bytestring bytestring cardano-api
    cardano-config cardano-crypto-class cardano-crypto-wrapper
    cardano-ledger-alonzo cardano-ledger-byron cardano-ledger-core
    cardano-ledger-shelley cardano-ledger-shelley-ma cardano-prelude
    cardano-protocol-tpraos cardano-slotting cborg containers
    contra-tracer deepseq directory dns ekg ekg-core filepath
    generic-data hostname io-classes iohk-monitoring iproute
    lobemo-backend-aggregation lobemo-backend-ekg
    lobemo-backend-monitoring lobemo-backend-trace-forwarder
    lobemo-scribe-systemd network network-mux nothunks
    optparse-applicative-fork ouroboros-consensus
    ouroboros-consensus-byron ouroboros-consensus-cardano
    ouroboros-consensus-protocol ouroboros-consensus-shelley
    ouroboros-network ouroboros-network-framework process psqueues
    safe-exceptions scientific small-steps stm strict-stm systemd text
    time tracer-transformers transformers transformers-except
    typed-protocols unix unordered-containers yaml
  ];
  executableHaskellDepends = [
    base cardano-config cardano-prelude optparse-applicative-fork text
  ];
  testHaskellDepends = [
    aeson base cardano-api cardano-prelude cardano-slotting directory
    hedgehog hedgehog-corpus iproute ouroboros-consensus
    ouroboros-network time unix
  ];
  license = lib.licenses.asl20;
}
