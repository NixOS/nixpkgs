{ mkDerivation, base, bytestring, containers, fetchgit, io-classes
, lib, network-mux, ouroboros-consensus, ouroboros-network
, ouroboros-network-framework
}:
mkDerivation {
  pname = "cardano-client";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/ouroboros-network/";
    sha256 = "18xk7r0h2pxrbx76d6flsxifh0a9rz1cj1rjqs1pbs5kdmy8b7kx";
    rev = "d2d219a86cda42787325bb8c20539a75c2667132";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/cardano-client; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    base bytestring containers io-classes network-mux
    ouroboros-consensus ouroboros-network ouroboros-network-framework
  ];
  description = "An API for ouroboros-network";
  license = lib.licenses.asl20;
}
