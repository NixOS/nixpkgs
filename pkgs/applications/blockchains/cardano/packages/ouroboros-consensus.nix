{ mkDerivation, base, base-deriving-via, base16-bytestring, bimap
, binary, bytestring, cardano-binary, cardano-crypto-class
, cardano-prelude, cardano-slotting, cborg, containers
, contra-tracer, deepseq, digest, directory, fetchgit, filelock
, filepath, hashable, io-classes, lib, measures, mtl, network-mux
, nothunks, ouroboros-network, ouroboros-network-framework
, psqueues, quiet, random, semialign, serialise, sop-core, stm
, streaming, strict-containers, strict-stm, text, these, time
, transformers, typed-protocols, unix, unix-bytestring, vector
}:
mkDerivation {
  pname = "ouroboros-consensus";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/ouroboros-network/";
    sha256 = "18xk7r0h2pxrbx76d6flsxifh0a9rz1cj1rjqs1pbs5kdmy8b7kx";
    rev = "d2d219a86cda42787325bb8c20539a75c2667132";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/ouroboros-consensus; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    base base-deriving-via base16-bytestring bimap binary bytestring
    cardano-binary cardano-crypto-class cardano-prelude
    cardano-slotting cborg containers contra-tracer deepseq digest
    directory filelock filepath hashable io-classes measures mtl
    network-mux nothunks ouroboros-network ouroboros-network-framework
    psqueues quiet random semialign serialise sop-core stm streaming
    strict-containers strict-stm text these time transformers
    typed-protocols unix unix-bytestring vector
  ];
  description = "Consensus layer for the Ouroboros blockchain protocol";
  license = lib.licenses.asl20;
}
