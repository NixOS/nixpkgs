{ mkDerivation, async, base, bytestring, cardano-prelude, cborg
, containers, contra-tracer, directory, dns, fetchgit, hashable
, io-classes, io-sim, iproute, lib, monoidal-synchronisation, mtl
, network, network-mux, nothunks, optparse-applicative
, ouroboros-network-testing, pretty-simple, QuickCheck
, quickcheck-instances, quiet, random, serialise, stm, strict-stm
, tasty, tasty-quickcheck, text, time, typed-protocols
, typed-protocols-cborg, typed-protocols-examples, Win32-network
}:
mkDerivation {
  pname = "ouroboros-network-framework";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/ouroboros-network/";
    sha256 = "18xk7r0h2pxrbx76d6flsxifh0a9rz1cj1rjqs1pbs5kdmy8b7kx";
    rev = "d2d219a86cda42787325bb8c20539a75c2667132";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/ouroboros-network-framework; echo source root reset to $sourceRoot";
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    async base bytestring cardano-prelude cborg containers
    contra-tracer dns hashable io-classes iproute
    monoidal-synchronisation mtl network network-mux nothunks
    ouroboros-network-testing quiet random stm strict-stm text time
    typed-protocols typed-protocols-cborg Win32-network
  ];
  executableHaskellDepends = [
    async base bytestring cborg contra-tracer directory io-classes
    network network-mux optparse-applicative random serialise
    strict-stm typed-protocols typed-protocols-examples
  ];
  testHaskellDepends = [
    base bytestring cardano-prelude cborg containers contra-tracer
    directory dns io-classes io-sim iproute monoidal-synchronisation
    network network-mux ouroboros-network-testing pretty-simple
    QuickCheck quickcheck-instances quiet serialise strict-stm tasty
    tasty-quickcheck text time typed-protocols typed-protocols-cborg
    typed-protocols-examples
  ];
  license = lib.licenses.asl20;
}
