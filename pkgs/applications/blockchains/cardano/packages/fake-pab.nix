{ mkDerivation, aeson, base, base16-bytestring, blaze-html
, bytestring, containers, cryptohash, fetchgit, http-client
, http-client-tls, http-media, http-types, immortal, lens, lib
, marlowe, monad-logger, mtl, optparse-applicative
, playground-common, plutus-ledger, plutus-ledger-api, plutus-tx
, postgresql-simple, purescript-bridge, resource-pool, servant
, servant-client, servant-client-core, servant-purescript
, servant-server, text, time, utf8-string, uuid, wai
, wai-app-static, wai-cors, warp, websockets
}:
mkDerivation {
  pname = "fake-pab";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/plutus/";
    sha256 = "1jicyk4hr8p0xksj4048gdxndrb42jz4wsnkhc3ymxbm5v6snalf";
    rev = "1efbb276ef1a10ca6961d0fd32e6141e9798bd11";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/fake-pab; echo source root reset to $sourceRoot";
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson base base16-bytestring blaze-html bytestring containers
    cryptohash http-client http-client-tls http-media marlowe
    monad-logger mtl playground-common plutus-ledger plutus-ledger-api
    plutus-tx postgresql-simple resource-pool servant servant-client
    servant-client-core servant-server text time utf8-string uuid
    wai-app-static wai-cors websockets
  ];
  executableHaskellDepends = [
    aeson base bytestring http-client http-types immortal lens marlowe
    monad-logger mtl optparse-applicative playground-common
    plutus-ledger-api postgresql-simple purescript-bridge resource-pool
    servant-client servant-purescript servant-server text utf8-string
    wai warp
  ];
  testHaskellDepends = [ base ];
  license = lib.licenses.asl20;
}
