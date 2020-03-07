{ mkDerivation, fetchpatch
, base, containers, gomp, hspec, QuickCheck, stdenv
, transformers, z3
}:
mkDerivation {
  pname = "z3";
  version = "408.0";
  sha256 = "13qkzy9wc17rm60i24fa9sx15ywbxq4a80g33w20887gvqyc0q53";
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [ base containers transformers ];
  librarySystemDepends = [ gomp z3 ];
  testHaskellDepends = [ base hspec QuickCheck ];
  homepage = "https://github.com/IagoAbal/haskell-z3";
  description = "Bindings for the Z3 Theorem Prover";
  license = stdenv.lib.licenses.bsd3;
  doCheck = false;
  patches = [
    (fetchpatch {
      url = "https://github.com/IagoAbal/haskell-z3/commit/b10e09b8a809fb5bbbb1ef86aeb62109ece99cae.patch";
      sha256 = "13fnrs27mg3985r3lwks8fxfxr5inrayy2cyx2867d92pnl3yry4";
    })
  ];
}
