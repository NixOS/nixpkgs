{ mkDerivation, base, deepseq, fetchgit, lib, mono-traversable
, primitive, QuickCheck, tasty, tasty-bench, tasty-quickcheck
, vector
}:
mkDerivation {
  pname = "word-array";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/plutus/";
    sha256 = "1jicyk4hr8p0xksj4048gdxndrb42jz4wsnkhc3ymxbm5v6snalf";
    rev = "1efbb276ef1a10ca6961d0fd32e6141e9798bd11";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/word-array; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    base deepseq mono-traversable primitive
  ];
  testHaskellDepends = [
    base mono-traversable QuickCheck tasty tasty-quickcheck vector
  ];
  benchmarkHaskellDepends = [
    base deepseq primitive tasty tasty-bench
  ];
  homepage = "https://github.com/plutus";
  license = lib.licenses.asl20;
}
