{ mkDerivation, base, bytestring, cborg, contra-tracer, fetchgit
, io-classes, io-sim, lib, QuickCheck, serialise, tasty
, tasty-quickcheck, time, typed-protocols, typed-protocols-cborg
}:
mkDerivation {
  pname = "typed-protocols-examples";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/ouroboros-network/";
    sha256 = "18xk7r0h2pxrbx76d6flsxifh0a9rz1cj1rjqs1pbs5kdmy8b7kx";
    rev = "d2d219a86cda42787325bb8c20539a75c2667132";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/typed-protocols-examples; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    base bytestring cborg contra-tracer io-classes serialise time
    typed-protocols typed-protocols-cborg
  ];
  testHaskellDepends = [
    base bytestring contra-tracer io-classes io-sim QuickCheck tasty
    tasty-quickcheck typed-protocols typed-protocols-cborg
  ];
  description = "Examples and tests for the typed-protocols framework";
  license = lib.licenses.asl20;
}
