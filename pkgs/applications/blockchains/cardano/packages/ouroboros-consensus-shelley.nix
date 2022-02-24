{ mkDerivation, base, base-deriving-via, bytestring, cardano-binary
, cardano-crypto-class, cardano-ledger-alonzo, cardano-ledger-core
, cardano-ledger-shelley, cardano-ledger-shelley-ma
, cardano-prelude, cardano-protocol-tpraos, cardano-slotting, cborg
, containers, data-default-class, deepseq, fetchgit, lib, measures
, mtl, nothunks, orphans-deriving-via, ouroboros-consensus
, ouroboros-consensus-protocol, ouroboros-network, serialise
, small-steps, strict-containers, text, transformers
}:
mkDerivation {
  pname = "ouroboros-consensus-shelley";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/ouroboros-network/";
    sha256 = "18xk7r0h2pxrbx76d6flsxifh0a9rz1cj1rjqs1pbs5kdmy8b7kx";
    rev = "d2d219a86cda42787325bb8c20539a75c2667132";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/ouroboros-consensus-shelley; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    base base-deriving-via bytestring cardano-binary
    cardano-crypto-class cardano-ledger-alonzo cardano-ledger-core
    cardano-ledger-shelley cardano-ledger-shelley-ma cardano-prelude
    cardano-protocol-tpraos cardano-slotting cborg containers
    data-default-class deepseq measures mtl nothunks
    orphans-deriving-via ouroboros-consensus
    ouroboros-consensus-protocol ouroboros-network serialise
    small-steps strict-containers text transformers
  ];
  description = "Shelley ledger integration in the Ouroboros consensus layer";
  license = lib.licenses.asl20;
}
