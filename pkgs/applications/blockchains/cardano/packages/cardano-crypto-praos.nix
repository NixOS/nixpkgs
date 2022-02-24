{ mkDerivation, base, bytestring, cardano-binary
, cardano-crypto-class, cardano-prelude, fetchgit, lib, libsodium
, nothunks
}:
mkDerivation {
  pname = "cardano-crypto-praos";
  version = "2.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-base/";
    sha256 = "0icq9y3nnl42fz536da84414av36g37894qnyw4rk3qkalksqwir";
    rev = "41545ba3ac6b3095966316a99883d678b5ab8da8";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/cardano-crypto-praos; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    base bytestring cardano-binary cardano-crypto-class cardano-prelude
    nothunks
  ];
  libraryPkgconfigDepends = [ libsodium ];
  description = "Crypto primitives from libsodium";
  license = lib.licenses.asl20;
}
