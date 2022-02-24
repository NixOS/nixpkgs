{ mkDerivation, base, base-deriving-via, fetchgit, lib, QuickCheck
, tasty, tasty-quickcheck
}:
mkDerivation {
  pname = "measures";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-base/";
    sha256 = "0icq9y3nnl42fz536da84414av36g37894qnyw4rk3qkalksqwir";
    rev = "41545ba3ac6b3095966316a99883d678b5ab8da8";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/measures; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [ base base-deriving-via ];
  testHaskellDepends = [ base QuickCheck tasty tasty-quickcheck ];
  description = "An abstraction for (tuples of) measured quantities";
  license = lib.licenses.asl20;
}
