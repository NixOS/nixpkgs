{ mkDerivation, aeson, base, bytestring, cardano-prelude
, cardano-prelude-test, cborg, containers, data-fix, fetchgit
, formatting, hedgehog, hspec, lib, nothunks, pretty-show
, primitive, QuickCheck, quickcheck-instances, recursion-schemes
, safe-exceptions, tagged, text, time, vector
}:
mkDerivation {
  pname = "cardano-binary";
  version = "1.5.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-base/";
    sha256 = "0icq9y3nnl42fz536da84414av36g37894qnyw4rk3qkalksqwir";
    rev = "41545ba3ac6b3095966316a99883d678b5ab8da8";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/binary; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    aeson base bytestring cardano-prelude cborg containers data-fix
    formatting nothunks primitive recursion-schemes safe-exceptions
    tagged text time vector
  ];
  testHaskellDepends = [
    base bytestring cardano-prelude cardano-prelude-test cborg
    containers formatting hedgehog hspec pretty-show QuickCheck
    quickcheck-instances tagged text time vector
  ];
  description = "Binary serialization for Cardano";
  license = lib.licenses.asl20;
}
