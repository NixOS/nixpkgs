{ mkDerivation, base, bytestring, cardano-binary, cardano-crypto
, cardano-crypto-class, cardano-crypto-wrapper
, cardano-ledger-byron, cardano-prelude, cardano-slotting, cborg
, containers, cryptonite, directory, fetchgit, filepath, formatting
, lib, mtl, nothunks, optparse-generic, ouroboros-consensus
, ouroboros-network, resourcet, serialise, streaming, text
}:
mkDerivation {
  pname = "ouroboros-consensus-byron";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/ouroboros-network/";
    sha256 = "18xk7r0h2pxrbx76d6flsxifh0a9rz1cj1rjqs1pbs5kdmy8b7kx";
    rev = "d2d219a86cda42787325bb8c20539a75c2667132";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/ouroboros-consensus-byron; echo source root reset to $sourceRoot";
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    base bytestring cardano-binary cardano-crypto cardano-crypto-class
    cardano-crypto-wrapper cardano-ledger-byron cardano-prelude
    cardano-slotting cborg containers cryptonite formatting mtl
    nothunks ouroboros-consensus ouroboros-network serialise text
  ];
  executableHaskellDepends = [
    base bytestring cardano-binary cardano-ledger-byron directory
    filepath mtl optparse-generic ouroboros-consensus ouroboros-network
    resourcet streaming text
  ];
  description = "Byron ledger integration in the Ouroboros consensus layer";
  license = lib.licenses.asl20;
}
