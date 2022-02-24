{ mkDerivation, aeson, aeson-casing, base, bytestring, containers
, cookie, cryptonite, data-default, deriving-compat, exceptions
, fetchgit, foldl, freer-simple, hashable, http-client
, http-client-tls, http-conduit, http-types, jwt, lens, lib, memory
, monad-logger, mtl, newtype-generics, openapi3, plutus-chain-index
, plutus-contract, plutus-ledger, plutus-tx, prettyprinter, process
, prometheus, purescript-bridge, recursion-schemes, row-types
, servant, servant-client, servant-purescript, servant-server
, servant-websockets, streaming, tasty, tasty-hunit
, template-haskell, text, time, time-out, time-units, transformers
, unordered-containers, uuid, wai
}:
mkDerivation {
  pname = "playground-common";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/plutus/";
    sha256 = "1jicyk4hr8p0xksj4048gdxndrb42jz4wsnkhc3ymxbm5v6snalf";
    rev = "1efbb276ef1a10ca6961d0fd32e6141e9798bd11";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/playground-common; echo source root reset to $sourceRoot";
  enableSeparateDataOutput = true;
  libraryHaskellDepends = [
    aeson aeson-casing base bytestring containers cookie cryptonite
    data-default deriving-compat exceptions foldl freer-simple hashable
    http-client http-client-tls http-conduit http-types jwt lens memory
    monad-logger mtl newtype-generics openapi3 plutus-chain-index
    plutus-contract plutus-ledger plutus-tx prettyprinter process
    prometheus purescript-bridge recursion-schemes row-types servant
    servant-client servant-purescript servant-server servant-websockets
    streaming template-haskell text time time-out time-units
    transformers unordered-containers uuid wai
  ];
  testHaskellDepends = [
    aeson base bytestring containers cryptonite freer-simple
    plutus-contract plutus-ledger recursion-schemes tasty tasty-hunit
    text
  ];
  license = lib.licenses.asl20;
}
