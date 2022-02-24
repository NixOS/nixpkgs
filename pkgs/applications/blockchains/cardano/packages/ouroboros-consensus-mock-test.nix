{ mkDerivation, base, bytestring, cardano-crypto-class
, cardano-slotting, cborg, containers, fetchgit, lib
, ouroboros-consensus, ouroboros-consensus-mock
, ouroboros-consensus-test, ouroboros-network, QuickCheck
, serialise, tasty, tasty-quickcheck
}:
mkDerivation {
  pname = "ouroboros-consensus-mock-test";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/ouroboros-network/";
    sha256 = "18xk7r0h2pxrbx76d6flsxifh0a9rz1cj1rjqs1pbs5kdmy8b7kx";
    rev = "d2d219a86cda42787325bb8c20539a75c2667132";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/ouroboros-consensus-mock-test; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    base bytestring cardano-crypto-class containers ouroboros-consensus
    ouroboros-consensus-mock ouroboros-consensus-test QuickCheck
    serialise
  ];
  testHaskellDepends = [
    base bytestring cardano-slotting cborg containers
    ouroboros-consensus ouroboros-consensus-mock
    ouroboros-consensus-test ouroboros-network QuickCheck serialise
    tasty tasty-quickcheck
  ];
  description = "Tests of the mock ledger integration in the Ouroboros consensus layer";
  license = lib.licenses.asl20;
}
