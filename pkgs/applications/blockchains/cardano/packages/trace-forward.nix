{ mkDerivation, aeson, async, base, bytestring, cborg, containers
, contra-tracer, extra, fetchgit, io-classes, io-sim, lib
, ouroboros-network-framework, QuickCheck, serialise, stm, tasty
, tasty-quickcheck, text, typed-protocols, typed-protocols-cborg
}:
mkDerivation {
  pname = "trace-forward";
  version = "0.1.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-node/";
    sha256 = "1hr00wqzmcyc3x0kp2hyw78rfmimf6z4zd4vv85b9zv3nqbjgrik";
    rev = "814df2c146f5d56f8c35a681fe75e85b905aed5d";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/trace-forward; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    aeson async base bytestring cborg containers contra-tracer extra
    io-classes ouroboros-network-framework serialise stm text
    typed-protocols typed-protocols-cborg
  ];
  testHaskellDepends = [
    aeson base bytestring contra-tracer io-classes io-sim
    ouroboros-network-framework QuickCheck serialise tasty
    tasty-quickcheck text typed-protocols
  ];
  description = "The forwarding protocols library for cardano node";
  license = lib.licenses.asl20;
}
