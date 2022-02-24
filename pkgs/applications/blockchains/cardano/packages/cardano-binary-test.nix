{ mkDerivation, base, bytestring, cardano-binary, cardano-prelude
, cardano-prelude-test, cborg, containers, fetchgit, formatting
, hedgehog, hspec, lib, pretty-show, QuickCheck
, quickcheck-instances, text, time, vector
}:
mkDerivation {
  pname = "cardano-binary-test";
  version = "1.3.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-base/";
    sha256 = "0icq9y3nnl42fz536da84414av36g37894qnyw4rk3qkalksqwir";
    rev = "41545ba3ac6b3095966316a99883d678b5ab8da8";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/binary/test; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    base bytestring cardano-binary cardano-prelude cardano-prelude-test
    cborg containers formatting hedgehog hspec pretty-show QuickCheck
    quickcheck-instances text time vector
  ];
  description = "Test helpers from cardano-binary exposed to other packages";
  license = lib.licenses.mit;
}
