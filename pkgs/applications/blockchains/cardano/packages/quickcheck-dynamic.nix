{ mkDerivation, base, containers, fetchgit, lib, QuickCheck, random
, tasty, tasty-hunit, tasty-quickcheck
}:
mkDerivation {
  pname = "quickcheck-dynamic";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/plutus/";
    sha256 = "1jicyk4hr8p0xksj4048gdxndrb42jz4wsnkhc3ymxbm5v6snalf";
    rev = "1efbb276ef1a10ca6961d0fd32e6141e9798bd11";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/quickcheck-dynamic; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [ base containers QuickCheck random ];
  testHaskellDepends = [
    base containers QuickCheck random tasty tasty-hunit
    tasty-quickcheck
  ];
  homepage = "https://github.com/iohk/plutus#readme";
  license = lib.licenses.asl20;
}
