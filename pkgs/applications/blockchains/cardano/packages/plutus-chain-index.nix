{ mkDerivation, aeson, base, beam-core, beam-migrate, beam-sqlite
, bytestring, cardano-api, cardano-ledger-alonzo
, cardano-ledger-byron, cardano-ledger-core
, cardano-ledger-shelley-ma, cardano-slotting, containers
, contra-tracer, cryptonite, data-default, exceptions, fetchgit
, fingertree, freer-extras, freer-simple, hedgehog, http-types
, io-classes, iohk-monitoring, lens, lib, memory, mtl, nothunks
, optparse-applicative, ouroboros-consensus
, ouroboros-consensus-byron, ouroboros-consensus-cardano
, ouroboros-consensus-shelley, ouroboros-network
, ouroboros-network-framework, plutus-core, plutus-ledger
, plutus-ledger-api, plutus-tx, prettyprinter, retry, semigroups
, serialise, servant, servant-client, servant-client-core
, servant-server, shelley-spec-ledger, sqlite-simple, stm
, strict-containers, tasty, tasty-hedgehog, text, time-units
, typed-protocols-examples, unordered-containers, warp, yaml
}:
mkDerivation {
  pname = "plutus-chain-index";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/plutus/";
    sha256 = "1jicyk4hr8p0xksj4048gdxndrb42jz4wsnkhc3ymxbm5v6snalf";
    rev = "1efbb276ef1a10ca6961d0fd32e6141e9798bd11";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/plutus-chain-index; echo source root reset to $sourceRoot";
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson base beam-core beam-migrate beam-sqlite bytestring
    cardano-api cardano-ledger-alonzo cardano-ledger-byron
    cardano-ledger-core cardano-ledger-shelley-ma containers
    contra-tracer cryptonite data-default exceptions fingertree
    freer-extras freer-simple http-types io-classes iohk-monitoring
    lens memory mtl nothunks ouroboros-consensus
    ouroboros-consensus-byron ouroboros-consensus-cardano
    ouroboros-consensus-shelley ouroboros-network
    ouroboros-network-framework plutus-core plutus-ledger
    plutus-ledger-api plutus-tx prettyprinter retry semigroups
    serialise servant servant-client servant-client-core servant-server
    shelley-spec-ledger sqlite-simple stm strict-containers text
    time-units typed-protocols-examples unordered-containers warp
  ];
  executableHaskellDepends = [
    aeson base beam-core beam-migrate beam-sqlite cardano-api
    cardano-slotting containers contra-tracer freer-extras freer-simple
    iohk-monitoring lens optparse-applicative ouroboros-network
    plutus-ledger prettyprinter sqlite-simple stm yaml
  ];
  testHaskellDepends = [
    base bytestring containers fingertree freer-simple hedgehog lens
    plutus-ledger plutus-ledger-api plutus-tx serialise tasty
    tasty-hedgehog
  ];
  homepage = "https://github.com/iohk/plutus#readme";
  license = lib.licenses.asl20;
}
