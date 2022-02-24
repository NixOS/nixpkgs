{ mkDerivation, base, bimap, byron-spec-chain, byron-spec-ledger
, cardano-binary, cardano-ledger-byron-test, cardano-slotting
, cborg, containers, fetchgit, lib, mtl, nothunks
, ouroboros-consensus, ouroboros-network, serialise, small-steps
, transformers
}:
mkDerivation {
  pname = "ouroboros-consensus-byronspec";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/ouroboros-network/";
    sha256 = "18xk7r0h2pxrbx76d6flsxifh0a9rz1cj1rjqs1pbs5kdmy8b7kx";
    rev = "d2d219a86cda42787325bb8c20539a75c2667132";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/ouroboros-consensus-byronspec; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    base bimap byron-spec-chain byron-spec-ledger cardano-binary
    cardano-ledger-byron-test cardano-slotting cborg containers mtl
    nothunks ouroboros-consensus ouroboros-network serialise
    small-steps transformers
  ];
  description = "ByronSpec ledger integration in the Ouroboros consensus layer";
  license = lib.licenses.asl20;
}
