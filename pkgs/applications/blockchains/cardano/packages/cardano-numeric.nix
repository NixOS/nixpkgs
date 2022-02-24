{ mkDerivation, base, fetchgit, hspec, hspec-discover, lattices
, lib, QuickCheck, safe
}:
mkDerivation {
  pname = "cardano-numeric";
  version = "2020.12.8";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-wallet/";
    sha256 = "1apzfy7qdgf6l0lb3icqz3rvaq2w3a53xq6wvhqnbfi8i7cacy03";
    rev = "a5085acbd2670c24251cf8d76a4e83c77a2679ba";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/lib/numeric; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [ base lattices safe ];
  testHaskellDepends = [ base hspec QuickCheck ];
  testToolDepends = [ hspec-discover ];
  homepage = "https://github.com/input-output-hk/cardano-wallet";
  description = "Types and functions for performing numerical calculations";
  license = lib.licenses.asl20;
}
