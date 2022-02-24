{ mkDerivation, async, base, binary, bytestring, contra-tracer
, fetchgit, lib, network, QuickCheck, stm, tasty, tasty-quickcheck
, time, Win32-network
}:
mkDerivation {
  pname = "ntp-client";
  version = "0.0.1";
  src = fetchgit {
    url = "https://github.com/input-output-hk/ouroboros-network/";
    sha256 = "18xk7r0h2pxrbx76d6flsxifh0a9rz1cj1rjqs1pbs5kdmy8b7kx";
    rev = "d2d219a86cda42787325bb8c20539a75c2667132";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/ntp-client; echo source root reset to $sourceRoot";
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    async base binary bytestring contra-tracer network stm time
    Win32-network
  ];
  executableHaskellDepends = [
    async base contra-tracer Win32-network
  ];
  testHaskellDepends = [
    base binary QuickCheck tasty tasty-quickcheck time
  ];
  license = lib.licenses.asl20;
}
