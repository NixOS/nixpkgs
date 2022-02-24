{ mkDerivation, aeson, base, cardano-binary, cborg, containers
, data-default-class, deepseq, fetchgit, fingertree, lib, nothunks
, serialise
}:
mkDerivation {
  pname = "strict-containers";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-base/";
    sha256 = "0icq9y3nnl42fz536da84414av36g37894qnyw4rk3qkalksqwir";
    rev = "41545ba3ac6b3095966316a99883d678b5ab8da8";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/strict-containers; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    aeson base cardano-binary cborg containers data-default-class
    deepseq fingertree nothunks serialise
  ];
  description = "Various strict container types";
  license = lib.licenses.asl20;
}
