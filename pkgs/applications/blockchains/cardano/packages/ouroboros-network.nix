{ mkDerivation, aeson, array, async, base, base16-bytestring
, bytestring, cardano-binary, cardano-prelude, cardano-slotting
, cborg, containers, contra-tracer, deepseq, deque, directory, dns
, fetchgit, filepath, fingertree, hashable, io-classes, io-sim
, iproute, lib, monoidal-synchronisation, mtl, network, network-mux
, nothunks, ouroboros-network-framework, ouroboros-network-testing
, pipes, process, process-extras, psqueues, QuickCheck
, quickcheck-instances, random, serialise, stm, strict-containers
, strict-stm, tasty, tasty-hunit, tasty-quickcheck, temporary, text
, time, typed-protocols, typed-protocols-cborg
, typed-protocols-examples, unix
}:
mkDerivation {
  pname = "ouroboros-network";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/ouroboros-network/";
    sha256 = "18xk7r0h2pxrbx76d6flsxifh0a9rz1cj1rjqs1pbs5kdmy8b7kx";
    rev = "d2d219a86cda42787325bb8c20539a75c2667132";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/ouroboros-network; echo source root reset to $sourceRoot";
  isLibrary = true;
  isExecutable = true;
  enableSeparateDataOutput = true;
  libraryHaskellDepends = [
    aeson async base base16-bytestring bytestring cardano-binary
    cardano-prelude cardano-slotting cborg containers contra-tracer
    deepseq directory dns fingertree hashable io-classes io-sim iproute
    monoidal-synchronisation network network-mux nothunks
    ouroboros-network-framework ouroboros-network-testing pipes
    psqueues QuickCheck quickcheck-instances random serialise
    strict-containers strict-stm tasty tasty-quickcheck text time
    typed-protocols typed-protocols-cborg unix
  ];
  executableHaskellDepends = [
    async base bytestring containers contra-tracer directory
    network-mux ouroboros-network-framework random serialise stm
    typed-protocols
  ];
  testHaskellDepends = [
    aeson array async base bytestring cardano-prelude cardano-slotting
    cborg containers contra-tracer deque directory dns filepath
    hashable io-classes io-sim iproute monoidal-synchronisation mtl
    network network-mux nothunks ouroboros-network-framework
    ouroboros-network-testing process process-extras psqueues
    QuickCheck quickcheck-instances random serialise strict-stm tasty
    tasty-hunit tasty-quickcheck temporary text time typed-protocols
    typed-protocols-examples
  ];
  doHaddock = false;
  description = "A networking layer for the Ouroboros blockchain protocol";
  license = lib.licenses.asl20;
}
