{ mkDerivation, base, bytestring, cardano-crypto-class
, cardano-crypto-wrapper, cardano-ledger-alonzo
, cardano-ledger-alonzo-test, cardano-ledger-byron
, cardano-ledger-core, cardano-ledger-shelley
, cardano-ledger-shelley-test, cardano-protocol-tpraos
, cardano-slotting, cborg, containers, fetchgit, filepath, lib, mtl
, ouroboros-consensus, ouroboros-consensus-byron
, ouroboros-consensus-byron-test, ouroboros-consensus-cardano
, ouroboros-consensus-protocol, ouroboros-consensus-shelley
, ouroboros-consensus-shelley-test, ouroboros-consensus-test
, ouroboros-network, QuickCheck, sop-core, strict-containers, tasty
, tasty-quickcheck
}:
mkDerivation {
  pname = "ouroboros-consensus-cardano-test";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/ouroboros-network/";
    sha256 = "18xk7r0h2pxrbx76d6flsxifh0a9rz1cj1rjqs1pbs5kdmy8b7kx";
    rev = "d2d219a86cda42787325bb8c20539a75c2667132";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/ouroboros-consensus-cardano-test; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    base cardano-crypto-class cardano-crypto-wrapper
    cardano-ledger-alonzo cardano-ledger-alonzo-test
    cardano-ledger-byron cardano-ledger-core cardano-ledger-shelley
    cardano-ledger-shelley-test cardano-protocol-tpraos
    cardano-slotting containers mtl ouroboros-consensus
    ouroboros-consensus-byron ouroboros-consensus-byron-test
    ouroboros-consensus-cardano ouroboros-consensus-protocol
    ouroboros-consensus-shelley ouroboros-consensus-shelley-test
    ouroboros-consensus-test ouroboros-network QuickCheck sop-core
    strict-containers
  ];
  testHaskellDepends = [
    base bytestring cardano-crypto-class cardano-ledger-alonzo
    cardano-ledger-byron cardano-ledger-core cardano-ledger-shelley
    cardano-protocol-tpraos cardano-slotting cborg containers filepath
    ouroboros-consensus ouroboros-consensus-byron
    ouroboros-consensus-byron-test ouroboros-consensus-cardano
    ouroboros-consensus-shelley ouroboros-consensus-shelley-test
    ouroboros-consensus-test ouroboros-network QuickCheck sop-core
    tasty tasty-quickcheck
  ];
  description = "Test of the instantation of the Ouroboros consensus layer used by Cardano";
  license = lib.licenses.asl20;
}
