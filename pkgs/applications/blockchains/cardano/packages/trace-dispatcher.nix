{ mkDerivation, aeson, async, base, bytestring, cborg, containers
, contra-tracer, ekg, ekg-core, ekg-forward, fetchgit, hostname
, lib, network, ouroboros-network-framework, QuickCheck, serialise
, stm, tasty, tasty-quickcheck, text, time, trace-forward
, unagi-chan, unix, unliftio, unliftio-core, unordered-containers
, yaml
}:
mkDerivation {
  pname = "trace-dispatcher";
  version = "1.29.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-node/";
    sha256 = "1hr00wqzmcyc3x0kp2hyw78rfmimf6z4zd4vv85b9zv3nqbjgrik";
    rev = "814df2c146f5d56f8c35a681fe75e85b905aed5d";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/trace-dispatcher; echo source root reset to $sourceRoot";
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson async base bytestring cborg containers contra-tracer ekg
    ekg-core ekg-forward hostname network ouroboros-network-framework
    serialise stm text time trace-forward unagi-chan unix unliftio
    unliftio-core unordered-containers yaml
  ];
  executableHaskellDepends = [
    aeson base bytestring containers ekg ekg-core hostname stm text
    time unagi-chan unliftio unliftio-core unordered-containers yaml
  ];
  testHaskellDepends = [
    aeson base bytestring containers ekg ekg-core hostname QuickCheck
    stm tasty tasty-quickcheck text time unagi-chan unliftio
    unliftio-core unordered-containers yaml
  ];
  description = "Package for development of simple and efficient tracers based on the arrow based contra-tracer package";
  license = "unknown";
  hydraPlatforms = lib.platforms.none;
}
