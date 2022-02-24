{ mkDerivation, aeson, async, base, bytestring, cardano-api
, cardano-binary, cardano-crypto-class, cardano-ledger-byron
, fetchgit, formatting, http-media, iohk-monitoring, lib, mtl
, network, optparse-applicative-fork, ouroboros-consensus-cardano
, ouroboros-network, prometheus, protolude, servant, servant-server
, streaming-commons, text, transformers-except, warp, yaml
}:
mkDerivation {
  pname = "cardano-submit-api";
  version = "3.1.2";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-node/";
    sha256 = "1hr00wqzmcyc3x0kp2hyw78rfmimf6z4zd4vv85b9zv3nqbjgrik";
    rev = "814df2c146f5d56f8c35a681fe75e85b905aed5d";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/cardano-submit-api; echo source root reset to $sourceRoot";
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson async base bytestring cardano-api cardano-binary
    cardano-crypto-class cardano-ledger-byron formatting http-media
    iohk-monitoring mtl network optparse-applicative-fork
    ouroboros-consensus-cardano ouroboros-network prometheus protolude
    servant servant-server streaming-commons text transformers-except
    warp yaml
  ];
  executableHaskellDepends = [ base optparse-applicative-fork ];
  testHaskellDepends = [ base ];
  homepage = "https://github.com/input-output-hk/cardano-node";
  description = "A web server that allows transactions to be POSTed to the cardano chain";
  license = lib.licenses.asl20;
}
