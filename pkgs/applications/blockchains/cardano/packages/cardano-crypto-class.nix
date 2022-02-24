{ mkDerivation, aeson, base, base16-bytestring, bytestring
, cardano-binary, cardano-prelude, cryptonite, deepseq, fetchgit
, ghc-prim, integer-gmp, lib, libsodium, memory, nothunks
, primitive, serialise, text, transformers, unix, vector
}:
mkDerivation {
  pname = "cardano-crypto-class";
  version = "2.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-base/";
    sha256 = "0icq9y3nnl42fz536da84414av36g37894qnyw4rk3qkalksqwir";
    rev = "41545ba3ac6b3095966316a99883d678b5ab8da8";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/cardano-crypto-class; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    aeson base base16-bytestring bytestring cardano-binary
    cardano-prelude cryptonite deepseq ghc-prim integer-gmp memory
    nothunks primitive serialise text transformers vector
  ];
  libraryPkgconfigDepends = [ libsodium ];
  testHaskellDepends = [ base bytestring unix ];
  description = "Type classes abstracting over cryptography primitives for Cardano";
  license = lib.licenses.asl20;
}
