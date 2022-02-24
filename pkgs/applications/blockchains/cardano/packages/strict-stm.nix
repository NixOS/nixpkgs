{ mkDerivation, base, fetchgit, io-classes, lib, stm }:
mkDerivation {
  pname = "strict-stm";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/ouroboros-network/";
    sha256 = "18xk7r0h2pxrbx76d6flsxifh0a9rz1cj1rjqs1pbs5kdmy8b7kx";
    rev = "d2d219a86cda42787325bb8c20539a75c2667132";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/strict-stm; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [ base io-classes stm ];
  description = "Strict STM interface polymorphic over stm implementation";
  license = lib.licenses.asl20;
}
