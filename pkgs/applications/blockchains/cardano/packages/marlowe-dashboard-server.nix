{ mkDerivation, aeson, base, fetchgit, http-client, http-client-tls
, http-types, lens, lib, monad-logger, mtl, optparse-applicative
, playground-common, plutus-ledger-api, purescript-bridge, servant
, servant-client, servant-client-core, servant-purescript
, servant-server, servant-websockets, text, uuid, wai
, wai-app-static, wai-cors, warp, websockets
}:
mkDerivation {
  pname = "marlowe-dashboard-server";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/plutus/";
    sha256 = "1jicyk4hr8p0xksj4048gdxndrb42jz4wsnkhc3ymxbm5v6snalf";
    rev = "1efbb276ef1a10ca6961d0fd32e6141e9798bd11";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/marlowe-dashboard-server; echo source root reset to $sourceRoot";
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson base http-client http-client-tls monad-logger mtl
    playground-common servant servant-client servant-client-core
    servant-server servant-websockets text uuid wai-app-static wai-cors
    websockets
  ];
  executableHaskellDepends = [
    aeson base http-client http-types lens monad-logger
    optparse-applicative playground-common plutus-ledger-api
    purescript-bridge servant-client servant-purescript servant-server
    text wai warp
  ];
  testHaskellDepends = [ base ];
  license = lib.licenses.asl20;
}
