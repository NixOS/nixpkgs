{ mkDerivation, array, base, bytestring, containers, deepseq, dlist
, fetchgit, filepath, ghc-prim, hashable, lib, list-t
, mono-traversable, pretty, primitive, QuickCheck
, quickcheck-instances, quickcheck-text, semigroups, tasty
, tasty-hunit, tasty-quickcheck, text, unordered-containers, vector
}:
mkDerivation {
  pname = "flat";
  version = "0.4.5";
  src = fetchgit {
    url = "https://github.com/Quid2/flat";
    sha256 = "1lrzknw765pz2j97nvv9ip3l1mcpf2zr4n56hwlz0rk7wq7ls4cm";
    rev = "ee59880f47ab835dbd73bea0847dab7869fc20d8";
    fetchSubmodules = true;
  };
  libraryHaskellDepends = [
    array base bytestring containers deepseq dlist ghc-prim hashable
    list-t mono-traversable pretty primitive QuickCheck
    quickcheck-instances semigroups text unordered-containers vector
  ];
  testHaskellDepends = [
    array base bytestring containers deepseq dlist filepath ghc-prim
    list-t mono-traversable pretty QuickCheck quickcheck-instances
    quickcheck-text tasty tasty-hunit tasty-quickcheck text
    unordered-containers vector
  ];
  homepage = "http://quid2.org";
  description = "Principled and efficient bit-oriented binary serialization";
  license = lib.licenses.bsd3;
}
