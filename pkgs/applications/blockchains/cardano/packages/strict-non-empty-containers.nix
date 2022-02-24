{ mkDerivation, base, cardano-wallet-test-utils, containers
, deepseq, fetchgit, hashable, hspec, hspec-core, hspec-discover
, lib, QuickCheck, quickcheck-classes, should-not-typecheck
}:
mkDerivation {
  pname = "strict-non-empty-containers";
  version = "2020.12.8";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-wallet/";
    sha256 = "1apzfy7qdgf6l0lb3icqz3rvaq2w3a53xq6wvhqnbfi8i7cacy03";
    rev = "a5085acbd2670c24251cf8d76a4e83c77a2679ba";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/lib/strict-non-empty-containers; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [ base containers deepseq hashable ];
  testHaskellDepends = [
    base cardano-wallet-test-utils containers hspec hspec-core
    QuickCheck quickcheck-classes should-not-typecheck
  ];
  testToolDepends = [ hspec-discover ];
  homepage = "https://github.com/input-output-hk/cardano-wallet";
  description = "Strict non-empty container types";
  license = lib.licenses.asl20;
}
