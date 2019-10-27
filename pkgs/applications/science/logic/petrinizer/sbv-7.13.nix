{ mkDerivation, array, async, base, bytestring, containers
, crackNum, deepseq, directory, doctest, filepath, generic-deriving
, ghc, Glob, hlint, mtl, pretty, process, QuickCheck, random
, stdenv, syb, tasty, tasty-golden, tasty-hunit, tasty-quickcheck
, template-haskell, time, z3
}:
mkDerivation {
  pname = "sbv";
  version = "7.13";
  sha256 = "0bk400swnb4s98c5p71ml1px6jndaiqhf5dj7zmnliyplqcgpfik";
  enableSeparateDataOutput = true;
  libraryHaskellDepends = [
    array async base containers crackNum deepseq directory filepath
    generic-deriving ghc mtl pretty process QuickCheck random syb
    template-haskell time
  ];
  testHaskellDepends = [
    base bytestring containers crackNum directory doctest filepath Glob
    hlint mtl QuickCheck random syb tasty tasty-golden tasty-hunit
    tasty-quickcheck template-haskell
  ];
  testSystemDepends = [ z3 ];
  homepage = "http://leventerkok.github.com/sbv/";
  description = "SMT Based Verification: Symbolic Haskell theorem prover using SMT solving";
  license = stdenv.lib.licenses.bsd3;
}
