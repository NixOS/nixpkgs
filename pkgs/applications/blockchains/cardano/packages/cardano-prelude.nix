{ mkDerivation, aeson, array, base, base16-bytestring, bytestring
, canonical-json, cborg, containers, fetchgit, formatting, ghc-heap
, ghc-prim, integer-gmp, lib, mtl, protolude, tagged, text, time
, vector
}:
mkDerivation {
  pname = "cardano-prelude";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-prelude/";
    sha256 = "00h10l5mmiza9819p9v5q5749nb9pzgi20vpzpy1d34zmh6gf1cj";
    rev = "bb4ed71ba8e587f672d06edf9d2e376f4b055555";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/cardano-prelude; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    aeson array base base16-bytestring bytestring canonical-json cborg
    containers formatting ghc-heap ghc-prim integer-gmp mtl protolude
    tagged text time vector
  ];
  description = "A Prelude replacement for the Cardano project";
  license = lib.licenses.mit;
}
