{ mkDerivation, aeson, base, base16-bytestring, base64-bytestring
, base64-bytestring-type, binary, bytestring, canonical-json
, cardano-binary, cardano-binary-test, cardano-crypto
, cardano-prelude, cardano-prelude-test, cryptonite, data-default
, fetchgit, formatting, hedgehog, lib, memory, mtl, nothunks, text
}:
mkDerivation {
  pname = "cardano-crypto-wrapper";
  version = "1.3.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-ledger/";
    sha256 = "0avzyiqq0m8njd41ck9kpn992yq676b1az9xs77977h7cf85y4wm";
    rev = "1a9ec4ae9e0b09d54e49b2a40c4ead37edadcce5";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/eras/byron/crypto; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    aeson base base16-bytestring base64-bytestring
    base64-bytestring-type binary bytestring canonical-json
    cardano-binary cardano-crypto cardano-prelude cryptonite
    data-default formatting memory mtl nothunks text
  ];
  testHaskellDepends = [
    base bytestring cardano-binary cardano-binary-test cardano-crypto
    cardano-prelude cardano-prelude-test cryptonite formatting hedgehog
    memory text
  ];
  description = "Cryptographic primitives used in the Cardano project";
  license = lib.licenses.asl20;
}
