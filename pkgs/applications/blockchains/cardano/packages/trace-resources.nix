{ mkDerivation, aeson, base, fetchgit, lib, QuickCheck, tasty
, tasty-quickcheck, text, trace-dispatcher, unix
}:
mkDerivation {
  pname = "trace-resources";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-node/";
    sha256 = "1hr00wqzmcyc3x0kp2hyw78rfmimf6z4zd4vv85b9zv3nqbjgrik";
    rev = "814df2c146f5d56f8c35a681fe75e85b905aed5d";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/trace-resources; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [ aeson base text trace-dispatcher unix ];
  testHaskellDepends = [
    aeson base QuickCheck tasty tasty-quickcheck text trace-dispatcher
  ];
  description = "Package for tracing resources for linux, mac and windows";
  license = "unknown";
  hydraPlatforms = lib.platforms.none;
}
