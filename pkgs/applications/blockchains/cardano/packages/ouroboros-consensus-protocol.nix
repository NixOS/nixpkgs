{ mkDerivation, base, cardano-binary, cardano-crypto-class
, cardano-ledger-core, cardano-ledger-shelley
, cardano-protocol-tpraos, cardano-slotting, cborg, containers
, fetchgit, lib, mtl, nothunks, ouroboros-consensus, serialise
, text
}:
mkDerivation {
  pname = "ouroboros-consensus-protocol";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/ouroboros-network/";
    sha256 = "18xk7r0h2pxrbx76d6flsxifh0a9rz1cj1rjqs1pbs5kdmy8b7kx";
    rev = "d2d219a86cda42787325bb8c20539a75c2667132";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/ouroboros-consensus-protocol; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    base cardano-binary cardano-crypto-class cardano-ledger-core
    cardano-ledger-shelley cardano-protocol-tpraos cardano-slotting
    cborg containers mtl nothunks ouroboros-consensus serialise text
  ];
  description = "Cardano consensus protocols";
  license = "unknown";
  hydraPlatforms = lib.platforms.none;
}
