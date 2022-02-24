{ mkDerivation, base, binary-search, byron-spec-chain
, byron-spec-ledger, bytestring, cardano-binary
, cardano-crypto-class, cardano-crypto-test, cardano-crypto-wrapper
, cardano-ledger-byron, cardano-ledger-byron-test, cardano-slotting
, cborg, containers, fetchgit, filepath, hedgehog-quickcheck, lib
, mtl, ouroboros-consensus, ouroboros-consensus-byron
, ouroboros-consensus-byronspec, ouroboros-consensus-test
, ouroboros-network, QuickCheck, serialise, small-steps
, small-steps-test, tasty, tasty-quickcheck
}:
mkDerivation {
  pname = "ouroboros-consensus-byron-test";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/ouroboros-network/";
    sha256 = "18xk7r0h2pxrbx76d6flsxifh0a9rz1cj1rjqs1pbs5kdmy8b7kx";
    rev = "d2d219a86cda42787325bb8c20539a75c2667132";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/ouroboros-consensus-byron-test; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    base byron-spec-ledger bytestring cardano-binary
    cardano-crypto-class cardano-crypto-test cardano-crypto-wrapper
    cardano-ledger-byron cardano-ledger-byron-test containers
    hedgehog-quickcheck mtl ouroboros-consensus
    ouroboros-consensus-byron ouroboros-consensus-byronspec
    ouroboros-consensus-test ouroboros-network QuickCheck serialise
  ];
  testHaskellDepends = [
    base binary-search byron-spec-chain byron-spec-ledger bytestring
    cardano-binary cardano-crypto-class cardano-crypto-wrapper
    cardano-ledger-byron cardano-ledger-byron-test cardano-slotting
    cborg containers filepath hedgehog-quickcheck mtl
    ouroboros-consensus ouroboros-consensus-byron
    ouroboros-consensus-byronspec ouroboros-consensus-test
    ouroboros-network QuickCheck small-steps small-steps-test tasty
    tasty-quickcheck
  ];
  description = "Test infrastructure for Byron";
  license = lib.licenses.asl20;
}
