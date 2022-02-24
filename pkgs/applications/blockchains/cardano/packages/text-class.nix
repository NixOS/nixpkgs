{ mkDerivation, base, casing, extra, fetchgit, formatting, hspec
, hspec-discover, lib, OddWord, QuickCheck, text, time
}:
mkDerivation {
  pname = "text-class";
  version = "2022.1.18";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-wallet/";
    sha256 = "1apzfy7qdgf6l0lb3icqz3rvaq2w3a53xq6wvhqnbfi8i7cacy03";
    rev = "a5085acbd2670c24251cf8d76a4e83c77a2679ba";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/lib/text-class; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    base casing extra formatting hspec OddWord QuickCheck text time
  ];
  testHaskellDepends = [ base hspec QuickCheck text time ];
  testToolDepends = [ hspec-discover ];
  homepage = "https://github.com/input-output-hk/cardano-wallet";
  description = "Extra helpers to convert data-types to and from Text";
  license = lib.licenses.asl20;
}
