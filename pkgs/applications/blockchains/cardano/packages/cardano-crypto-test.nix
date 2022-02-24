{ mkDerivation, base, bytestring, cardano-binary
, cardano-binary-test, cardano-crypto, cardano-crypto-wrapper
, cardano-prelude, cardano-prelude-test, cryptonite, fetchgit
, hedgehog, lib, memory
}:
mkDerivation {
  pname = "cardano-crypto-test";
  version = "1.3.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-ledger/";
    sha256 = "0avzyiqq0m8njd41ck9kpn992yq676b1az9xs77977h7cf85y4wm";
    rev = "1a9ec4ae9e0b09d54e49b2a40c4ead37edadcce5";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/eras/byron/crypto/test; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    base bytestring cardano-binary cardano-binary-test cardano-crypto
    cardano-crypto-wrapper cardano-prelude cardano-prelude-test
    cryptonite hedgehog memory
  ];
  description = "Test helpers from cardano-crypto exposed to other packages";
  license = lib.licenses.asl20;
}
