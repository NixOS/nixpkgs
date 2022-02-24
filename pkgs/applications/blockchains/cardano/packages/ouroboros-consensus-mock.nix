{ mkDerivation, base, bimap, bytestring, cardano-binary
, cardano-crypto-class, cardano-slotting, cborg, containers
, deepseq, fetchgit, hashable, lib, mtl, nothunks
, ouroboros-consensus, ouroboros-network, serialise, time
}:
mkDerivation {
  pname = "ouroboros-consensus-mock";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/ouroboros-network/";
    sha256 = "18xk7r0h2pxrbx76d6flsxifh0a9rz1cj1rjqs1pbs5kdmy8b7kx";
    rev = "d2d219a86cda42787325bb8c20539a75c2667132";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/ouroboros-consensus-mock; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    base bimap bytestring cardano-binary cardano-crypto-class
    cardano-slotting cborg containers deepseq hashable mtl nothunks
    ouroboros-consensus ouroboros-network serialise time
  ];
  description = "Mock ledger integration in the Ouroboros consensus layer";
  license = lib.licenses.asl20;
}
