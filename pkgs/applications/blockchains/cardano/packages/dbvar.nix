{ mkDerivation, base, conduit, containers, exceptions, fetchgit
, generic-lens, hspec, hspec-discover, io-classes, io-sim, lib
, monad-logger, persistent, persistent-sqlite, QuickCheck, safe
, say, semigroupoids, stm, text, transformers
}:
mkDerivation {
  pname = "dbvar";
  version = "2021.8.23";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-wallet/";
    sha256 = "1apzfy7qdgf6l0lb3icqz3rvaq2w3a53xq6wvhqnbfi8i7cacy03";
    rev = "a5085acbd2670c24251cf8d76a4e83c77a2679ba";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/lib/dbvar; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    base conduit containers exceptions generic-lens io-classes
    monad-logger persistent persistent-sqlite safe say semigroupoids
    stm text transformers
  ];
  testHaskellDepends = [ base hspec io-classes io-sim QuickCheck ];
  testToolDepends = [ hspec-discover ];
  homepage = "https://github.com/input-output-hk/cardano-wallet";
  description = "Mutable variables that are written to disk using delta encodings";
  license = lib.licenses.asl20;
}
