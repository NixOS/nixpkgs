{ mkDerivation, aeson, aeson-pretty, async, base, beam-core
, beam-migrate, beam-sqlite, bytestring, cardano-api, cardano-cli
, cardano-crypto, cardano-ledger-byron, cardano-node
, cardano-prelude, cardano-slotting, cborg, clock, containers
, contra-tracer, cryptonite, data-default, either, exceptions
, fetchgit, filepath, fingertree, freer-extras, freer-simple
, generic-arbitrary, hedgehog, http-client, http-client-tls
, http-types, io-classes, iohk-monitoring, lens, lib
, lobemo-backend-ekg, memory, monad-logger, mtl, mwc-random
, network, network-mux, newtype-generics, nothunks, openapi3
, optparse-applicative, ouroboros-consensus
, ouroboros-consensus-byron, ouroboros-consensus-cardano
, ouroboros-consensus-shelley, ouroboros-network
, ouroboros-network-framework, playground-common
, plutus-chain-index, plutus-contract, plutus-ledger
, plutus-ledger-api, plutus-tx, plutus-tx-plugin, plutus-use-cases
, pretty-simple, prettyprinter, primitive, purescript-bridge
, QuickCheck, quickcheck-instances, random, rate-limit, row-types
, scientific, serialise, servant, servant-client, servant-openapi3
, servant-options, servant-purescript, servant-server
, servant-swagger-ui, servant-websockets, signal, smallcheck
, sqlite-simple, stm, tagged, tasty, tasty-hedgehog, tasty-hunit
, tasty-quickcheck, tasty-smallcheck, text, time, time-units
, transformers, typed-protocols, typed-protocols-examples
, unliftio-core, unordered-containers, uuid, vector, wai, wai-cors
, warp, websockets, Win32-network, yaml
}:
mkDerivation {
  pname = "plutus-pab";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/plutus/";
    sha256 = "1jicyk4hr8p0xksj4048gdxndrb42jz4wsnkhc3ymxbm5v6snalf";
    rev = "1efbb276ef1a10ca6961d0fd32e6141e9798bd11";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/plutus-pab; echo source root reset to $sourceRoot";
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson aeson-pretty async base beam-core beam-migrate beam-sqlite
    bytestring cardano-api cardano-crypto cardano-ledger-byron
    cardano-prelude cardano-slotting cborg containers contra-tracer
    cryptonite data-default exceptions fingertree freer-extras
    freer-simple generic-arbitrary hedgehog http-client http-client-tls
    http-types io-classes iohk-monitoring lens lobemo-backend-ekg
    memory monad-logger mtl mwc-random network network-mux
    newtype-generics nothunks openapi3 optparse-applicative
    ouroboros-consensus ouroboros-consensus-byron
    ouroboros-consensus-cardano ouroboros-consensus-shelley
    ouroboros-network ouroboros-network-framework playground-common
    plutus-chain-index plutus-contract plutus-ledger plutus-ledger-api
    plutus-tx plutus-tx-plugin prettyprinter primitive
    purescript-bridge QuickCheck quickcheck-instances random row-types
    scientific serialise servant servant-client servant-openapi3
    servant-options servant-purescript servant-server
    servant-swagger-ui servant-websockets sqlite-simple stm tagged text
    time time-units transformers typed-protocols
    typed-protocols-examples unliftio-core unordered-containers uuid
    vector wai wai-cors warp websockets Win32-network yaml
  ];
  libraryToolDepends = [ cardano-cli cardano-node ];
  executableHaskellDepends = [
    aeson aeson-pretty async base bytestring cardano-api
    cardano-slotting clock containers contra-tracer data-default either
    filepath freer-extras freer-simple hedgehog http-client
    http-client-tls iohk-monitoring lens lobemo-backend-ekg
    monad-logger mtl mwc-random openapi3 optparse-applicative
    playground-common plutus-chain-index plutus-contract plutus-ledger
    plutus-tx plutus-use-cases pretty-simple prettyprinter primitive
    purescript-bridge QuickCheck quickcheck-instances rate-limit
    row-types servant-client servant-purescript servant-server signal
    smallcheck stm tasty tasty-quickcheck tasty-smallcheck text
    time-units transformers unliftio-core uuid yaml
  ];
  testHaskellDepends = [
    aeson aeson-pretty async base bytestring cardano-api containers
    data-default freer-extras freer-simple hedgehog http-client
    http-client-tls iohk-monitoring lens monad-logger mtl openapi3
    playground-common plutus-contract plutus-ledger plutus-tx
    plutus-use-cases prettyprinter purescript-bridge QuickCheck
    quickcheck-instances row-types servant-client servant-server
    smallcheck stm tasty tasty-hedgehog tasty-hunit tasty-quickcheck
    tasty-smallcheck text transformers uuid yaml
  ];
  homepage = "https://github.com/iohk/plutus#readme";
  license = lib.licenses.asl20;
}
