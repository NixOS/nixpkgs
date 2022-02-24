{ mkDerivation, base, bytestring, cardano-binary
, cardano-crypto-class, cardano-crypto-praos, cardano-prelude
, cborg, criterion, cryptonite, fetchgit, formatting, lib, nothunks
, QuickCheck, quickcheck-instances, tasty, tasty-quickcheck
}:
mkDerivation {
  pname = "cardano-crypto-tests";
  version = "2.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-base/";
    sha256 = "0icq9y3nnl42fz536da84414av36g37894qnyw4rk3qkalksqwir";
    rev = "41545ba3ac6b3095966316a99883d678b5ab8da8";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/cardano-crypto-tests; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    base bytestring cardano-binary cardano-crypto-class
    cardano-crypto-praos cardano-prelude cborg criterion cryptonite
    formatting nothunks QuickCheck quickcheck-instances tasty
    tasty-quickcheck
  ];
  testHaskellDepends = [ base cardano-crypto-class tasty ];
  benchmarkHaskellDepends = [ base cardano-crypto-class criterion ];
  description = "Tests for cardano-crypto-class and -praos";
  license = lib.licenses.asl20;
}
