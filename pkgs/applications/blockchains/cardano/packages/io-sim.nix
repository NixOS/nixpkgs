{ mkDerivation, array, base, containers, exceptions, fetchgit
, io-classes, lib, psqueues, QuickCheck, quiet, strict-stm, tasty
, tasty-quickcheck, time
}:
mkDerivation {
  pname = "io-sim";
  version = "0.2.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/ouroboros-network/";
    sha256 = "18xk7r0h2pxrbx76d6flsxifh0a9rz1cj1rjqs1pbs5kdmy8b7kx";
    rev = "d2d219a86cda42787325bb8c20539a75c2667132";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/io-sim; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    base containers exceptions io-classes psqueues quiet time
  ];
  testHaskellDepends = [
    array base containers io-classes QuickCheck strict-stm tasty
    tasty-quickcheck time
  ];
  description = "A pure simlator for monadic concurrency with STM";
  license = lib.licenses.asl20;
}
