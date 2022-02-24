{ mkDerivation, base, basement, bytestring, cryptonite, deepseq
, fetchgit, foundation, gauge, hashable, integer-gmp, lib, memory
}:
mkDerivation {
  pname = "cardano-crypto";
  version = "1.1.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-crypto/";
    sha256 = "1n87i15x54s0cjkh3nsxs4r1x016cdw1fypwmr68936n3xxsjn6q";
    rev = "f73079303f663e028288f9f4a9e08bcca39a923e";
    fetchSubmodules = true;
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    base basement bytestring cryptonite deepseq foundation hashable
    integer-gmp memory
  ];
  testHaskellDepends = [
    base basement bytestring cryptonite foundation memory
  ];
  benchmarkHaskellDepends = [
    base bytestring cryptonite gauge memory
  ];
  homepage = "https://github.com/input-output-hk/cardano-crypto#readme";
  description = "Cryptography primitives for cardano";
  license = lib.licenses.mit;
}
