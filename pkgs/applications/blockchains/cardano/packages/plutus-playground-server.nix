{ mkDerivation, adjunctions, aeson, aeson-pretty, base, bytestring
, containers, cookie, cryptonite, data-default, data-default-class
, exceptions, fetchgit, file-embed, filepath, freer-extras
, http-client, http-client-tls, http-conduit, http-types
, insert-ordered-containers, jwt, lens, lib, monad-logger, mtl
, newtype-generics, optparse-applicative, playground-common
, plutus-contract, plutus-ledger, plutus-tx, plutus-tx-plugin
, purescript-bridge, recursion-schemes, regex-compat, row-types
, servant, servant-client, servant-client-core, servant-foreign
, servant-purescript, servant-server, tasty, tasty-golden
, tasty-hunit, template-haskell, text, time, time-units
, transformers, wai, wai-cors, warp, web-ghc
}:
mkDerivation {
  pname = "plutus-playground-server";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/plutus/";
    sha256 = "1jicyk4hr8p0xksj4048gdxndrb42jz4wsnkhc3ymxbm5v6snalf";
    rev = "1efbb276ef1a10ca6961d0fd32e6141e9798bd11";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/plutus-playground-server; echo source root reset to $sourceRoot";
  isLibrary = true;
  isExecutable = true;
  enableSeparateDataOutput = true;
  libraryHaskellDepends = [
    aeson base bytestring containers cookie cryptonite data-default
    exceptions file-embed freer-extras http-client http-client-tls
    http-conduit http-types jwt lens monad-logger mtl newtype-generics
    playground-common plutus-contract plutus-ledger plutus-tx
    plutus-tx-plugin recursion-schemes regex-compat row-types servant
    servant-client servant-client-core servant-purescript
    servant-server template-haskell text time time-units transformers
    wai-cors web-ghc
  ];
  executableHaskellDepends = [
    adjunctions aeson aeson-pretty base bytestring containers
    data-default data-default-class exceptions filepath freer-extras
    http-types lens monad-logger mtl optparse-applicative
    playground-common plutus-contract plutus-ledger plutus-tx
    plutus-tx-plugin purescript-bridge recursion-schemes row-types
    servant servant-foreign servant-purescript servant-server text
    time-units transformers wai warp web-ghc
  ];
  testHaskellDepends = [
    aeson base bytestring insert-ordered-containers mtl
    newtype-generics playground-common plutus-contract plutus-ledger
    plutus-tx plutus-tx-plugin tasty tasty-golden tasty-hunit text
    time-units transformers web-ghc
  ];
  doHaddock = false;
  homepage = "https://github.com/iohk/plutus#readme";
  license = lib.licenses.asl20;
}
