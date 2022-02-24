{ mkDerivation, aeson, base, data-default-class, exceptions
, fetchgit, filepath, http-types, lib, monad-logger, mtl
, newtype-generics, optparse-applicative, playground-common
, prometheus, regex-compat, servant, servant-client, servant-server
, tasty, temporary, text, time-units, wai, wai-cors, wai-extra
, warp, yaml
}:
mkDerivation {
  pname = "web-ghc";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/plutus/";
    sha256 = "1jicyk4hr8p0xksj4048gdxndrb42jz4wsnkhc3ymxbm5v6snalf";
    rev = "1efbb276ef1a10ca6961d0fd32e6141e9798bd11";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/web-ghc; echo source root reset to $sourceRoot";
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson base exceptions filepath mtl newtype-generics
    playground-common regex-compat servant servant-client
    servant-server temporary text time-units
  ];
  executableHaskellDepends = [
    base data-default-class exceptions http-types monad-logger mtl
    optparse-applicative playground-common prometheus servant
    servant-server text time-units wai wai-cors wai-extra warp yaml
  ];
  testHaskellDepends = [ base tasty ];
  homepage = "https://github.com/iohk/plutus#readme";
  license = lib.licenses.asl20;
}
