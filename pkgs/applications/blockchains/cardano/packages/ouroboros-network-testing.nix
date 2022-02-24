{ mkDerivation, base, cborg, containers, contra-tracer, deque
, fetchgit, io-classes, io-sim, lib, network-mux, psqueues
, QuickCheck, serialise, tasty, tasty-quickcheck
}:
mkDerivation {
  pname = "ouroboros-network-testing";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/ouroboros-network/";
    sha256 = "18xk7r0h2pxrbx76d6flsxifh0a9rz1cj1rjqs1pbs5kdmy8b7kx";
    rev = "d2d219a86cda42787325bb8c20539a75c2667132";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/ouroboros-network-testing; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    base cborg containers contra-tracer deque io-classes io-sim
    network-mux psqueues QuickCheck serialise
  ];
  testHaskellDepends = [ base QuickCheck tasty tasty-quickcheck ];
  description = "Common modules used for testing in ouroboros-network and ouroboros-consensus";
  license = lib.licenses.asl20;
}
