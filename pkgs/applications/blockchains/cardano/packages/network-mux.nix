{ mkDerivation, aeson, array, base, binary, bytestring, cborg
, containers, contra-tracer, directory, fetchgit, io-classes
, io-sim, lib, monoidal-synchronisation, network, process
, QuickCheck, quiet, serialise, splitmix, statistics-linreg, stm
, strict-stm, tasty, tasty-quickcheck, tdigest, text, time, vector
, Win32-network
}:
mkDerivation {
  pname = "network-mux";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/ouroboros-network/";
    sha256 = "18xk7r0h2pxrbx76d6flsxifh0a9rz1cj1rjqs1pbs5kdmy8b7kx";
    rev = "d2d219a86cda42787325bb8c20539a75c2667132";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/network-mux; echo source root reset to $sourceRoot";
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    array base binary bytestring containers contra-tracer io-classes
    monoidal-synchronisation network process quiet statistics-linreg
    strict-stm time vector
  ];
  executableHaskellDepends = [
    aeson base bytestring cborg contra-tracer directory io-classes
    network serialise stm strict-stm tdigest text
  ];
  testHaskellDepends = [
    base binary bytestring cborg containers contra-tracer io-classes
    io-sim network process QuickCheck serialise splitmix strict-stm
    tasty tasty-quickcheck time Win32-network
  ];
  description = "Multiplexing library";
  license = lib.licenses.asl20;
}
