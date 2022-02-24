{ mkDerivation, aeson, base, bytestring, cardano-binary
, cardano-crypto-class, cardano-crypto-wrapper
, cardano-ledger-alonzo, cardano-ledger-byron, cardano-ledger-core
, cardano-ledger-shelley, cardano-ledger-shelley-ma
, cardano-prelude, cardano-slotting, cborg, containers
, contra-tracer, fetchgit, lib, mtl, nothunks, optparse-applicative
, ouroboros-consensus, ouroboros-consensus-byron
, ouroboros-consensus-protocol, ouroboros-consensus-shelley
, ouroboros-network, plutus-ledger-api, serialise
, strict-containers, text, these
}:
mkDerivation {
  pname = "ouroboros-consensus-cardano";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/ouroboros-network/";
    sha256 = "18xk7r0h2pxrbx76d6flsxifh0a9rz1cj1rjqs1pbs5kdmy8b7kx";
    rev = "d2d219a86cda42787325bb8c20539a75c2667132";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/ouroboros-consensus-cardano; echo source root reset to $sourceRoot";
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    base bytestring cardano-binary cardano-crypto-class
    cardano-ledger-alonzo cardano-ledger-byron cardano-ledger-core
    cardano-ledger-shelley cardano-ledger-shelley-ma cardano-prelude
    cardano-slotting cborg containers mtl nothunks ouroboros-consensus
    ouroboros-consensus-byron ouroboros-consensus-protocol
    ouroboros-consensus-shelley ouroboros-network these
  ];
  executableHaskellDepends = [
    aeson base bytestring cardano-binary cardano-crypto-wrapper
    cardano-ledger-alonzo cardano-ledger-byron cardano-ledger-core
    cardano-ledger-shelley cborg containers contra-tracer mtl nothunks
    optparse-applicative ouroboros-consensus ouroboros-consensus-byron
    ouroboros-consensus-shelley ouroboros-network plutus-ledger-api
    serialise strict-containers text
  ];
  description = "The instantation of the Ouroboros consensus layer used by Cardano";
  license = lib.licenses.asl20;
}
