{ mkDerivation, async, base, bytestring, fetchgit, lib, mtl
, QuickCheck, stm, tasty, tasty-quickcheck, time
}:
mkDerivation {
  pname = "io-classes";
  version = "0.2.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/ouroboros-network/";
    sha256 = "18xk7r0h2pxrbx76d6flsxifh0a9rz1cj1rjqs1pbs5kdmy8b7kx";
    rev = "d2d219a86cda42787325bb8c20539a75c2667132";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/io-classes; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [ async base bytestring mtl stm time ];
  testHaskellDepends = [ base QuickCheck tasty tasty-quickcheck ];
  description = "Type classes for concurrency with STM, ST and timing";
  license = lib.licenses.asl20;
}
