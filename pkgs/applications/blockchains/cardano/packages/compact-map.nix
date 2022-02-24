{ mkDerivation, base, cardano-binary, cardano-crypto-class
, cardano-prelude, containers, criterion, deepseq, fetchgit, lib
, nothunks, prettyprinter, primitive, QuickCheck
, quickcheck-classes-base, random, tasty, tasty-hunit
, tasty-quickcheck, text, vector, vector-algorithms
}:
mkDerivation {
  pname = "compact-map";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-ledger/";
    sha256 = "0avzyiqq0m8njd41ck9kpn992yq676b1az9xs77977h7cf85y4wm";
    rev = "1a9ec4ae9e0b09d54e49b2a40c4ead37edadcce5";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/libs/compact-map; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    base cardano-binary cardano-crypto-class cardano-prelude containers
    deepseq nothunks prettyprinter primitive random text vector
    vector-algorithms
  ];
  testHaskellDepends = [
    base cardano-prelude containers QuickCheck quickcheck-classes-base
    random tasty tasty-hunit tasty-quickcheck
  ];
  benchmarkHaskellDepends = [ base containers criterion random ];
  homepage = "https://github.com/input-output-hk/cardano-legder-specs";
  description = "A KeyMap that is based on collisionless HashMap implementation";
  license = lib.licenses.asl20;
}
