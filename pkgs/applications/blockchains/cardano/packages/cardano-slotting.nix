{ mkDerivation, aeson, base, cardano-binary, cborg, deepseq
, fetchgit, lib, mmorph, nothunks, quiet, serialise, time
}:
mkDerivation {
  pname = "cardano-slotting";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-base/";
    sha256 = "0icq9y3nnl42fz536da84414av36g37894qnyw4rk3qkalksqwir";
    rev = "41545ba3ac6b3095966316a99883d678b5ab8da8";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/slotting; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    aeson base cardano-binary cborg deepseq mmorph nothunks quiet
    serialise time
  ];
  description = "Key slotting types for cardano libraries";
  license = lib.licenses.asl20;
}
