{ mkDerivation, aeson, base, bytestring, containers, cookie
, directory, exceptions, fetchgit, file-embed, filepath, hashable
, http-client, http-client-tls, http-conduit, http-types, jwt, lens
, lib, marlowe, marlowe-actus, marlowe-symbolic, monad-logger, mtl
, newtype-generics, optparse-applicative, playground-common
, plutus-ledger, plutus-tx, process, purescript-bridge, servant
, servant-client, servant-client-core, servant-foreign
, servant-purescript, servant-server, stm, temporary, text, time
, time-units, transformers, unordered-containers, uuid, validation
, wai, wai-cors, warp, web-ghc
}:
mkDerivation {
  pname = "marlowe-playground-server";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/plutus/";
    sha256 = "1jicyk4hr8p0xksj4048gdxndrb42jz4wsnkhc3ymxbm5v6snalf";
    rev = "1efbb276ef1a10ca6961d0fd32e6141e9798bd11";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/marlowe-playground-server; echo source root reset to $sourceRoot";
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson base bytestring containers cookie directory exceptions
    file-embed filepath hashable http-client http-client-tls
    http-conduit http-types jwt lens marlowe marlowe-actus
    marlowe-symbolic monad-logger mtl newtype-generics
    playground-common process servant servant-client
    servant-client-core servant-purescript servant-server stm temporary
    text time time-units transformers unordered-containers uuid
    validation wai-cors web-ghc
  ];
  executableHaskellDepends = [
    aeson base bytestring containers directory filepath http-client
    http-types lens marlowe marlowe-actus marlowe-symbolic monad-logger
    mtl optparse-applicative playground-common plutus-ledger plutus-tx
    purescript-bridge servant-client servant-foreign servant-purescript
    servant-server text time time-units wai warp web-ghc
  ];
  testHaskellDepends = [ base ];
  license = lib.licenses.asl20;
}
