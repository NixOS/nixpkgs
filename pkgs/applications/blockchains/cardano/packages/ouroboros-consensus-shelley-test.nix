{ mkDerivation, base, bytestring, cardano-crypto-class
, cardano-ledger-alonzo, cardano-ledger-alonzo-test
, cardano-ledger-core, cardano-ledger-shelley
, cardano-ledger-shelley-ma, cardano-ledger-shelley-ma-test
, cardano-ledger-shelley-test, cardano-protocol-tpraos
, cardano-slotting, cborg, containers, fetchgit, filepath
, generic-random, lib, mtl, ouroboros-consensus
, ouroboros-consensus-protocol, ouroboros-consensus-shelley
, ouroboros-consensus-test, ouroboros-network, QuickCheck, quiet
, small-steps, strict-containers, tasty, tasty-quickcheck
, transformers
}:
mkDerivation {
  pname = "ouroboros-consensus-shelley-test";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/ouroboros-network/";
    sha256 = "18xk7r0h2pxrbx76d6flsxifh0a9rz1cj1rjqs1pbs5kdmy8b7kx";
    rev = "d2d219a86cda42787325bb8c20539a75c2667132";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/ouroboros-consensus-shelley-test; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    base bytestring cardano-crypto-class cardano-ledger-alonzo
    cardano-ledger-alonzo-test cardano-ledger-core
    cardano-ledger-shelley cardano-ledger-shelley-ma
    cardano-ledger-shelley-ma-test cardano-ledger-shelley-test
    cardano-protocol-tpraos cardano-slotting containers generic-random
    mtl ouroboros-consensus ouroboros-consensus-protocol
    ouroboros-consensus-shelley ouroboros-consensus-test
    ouroboros-network QuickCheck quiet small-steps strict-containers
    transformers
  ];
  testHaskellDepends = [
    base bytestring cardano-crypto-class cardano-ledger-alonzo
    cardano-ledger-alonzo-test cardano-ledger-core
    cardano-ledger-shelley cardano-slotting cborg containers filepath
    ouroboros-consensus ouroboros-consensus-shelley
    ouroboros-consensus-test ouroboros-network QuickCheck tasty
    tasty-quickcheck
  ];
  description = "Test infrastructure for Shelley";
  license = lib.licenses.asl20;
}
