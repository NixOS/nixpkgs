{ mkDerivation, aeson, aeson-pretty, attoparsec, base
, base16-bytestring, bytestring, canonical-json, cardano-prelude
, containers, cryptonite, fetchgit, formatting, ghc-heap, ghc-prim
, hedgehog, hspec, lib, pretty-show, QuickCheck
, quickcheck-instances, template-haskell, text, time
}:
mkDerivation {
  pname = "cardano-prelude-test";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-prelude/";
    sha256 = "00h10l5mmiza9819p9v5q5749nb9pzgi20vpzpy1d34zmh6gf1cj";
    rev = "bb4ed71ba8e587f672d06edf9d2e376f4b055555";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/cardano-prelude-test; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    aeson aeson-pretty attoparsec base base16-bytestring bytestring
    canonical-json cardano-prelude containers cryptonite formatting
    hedgehog hspec pretty-show QuickCheck quickcheck-instances
    template-haskell text time
  ];
  testHaskellDepends = [
    base bytestring cardano-prelude ghc-heap ghc-prim hedgehog text
  ];
  description = "Utility types and functions for testing Cardano";
  license = lib.licenses.mit;
}
