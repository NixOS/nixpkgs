{ mkDerivation, base, base16-bytestring, bimap, byron-spec-chain
, byron-spec-ledger, bytestring, cardano-binary
, cardano-binary-test, cardano-crypto, cardano-crypto-test
, cardano-crypto-wrapper, cardano-ledger-byron, cardano-prelude
, cardano-prelude-test, containers, directory, fetchgit, filepath
, formatting, generic-monoid, hedgehog, lib, microlens, resourcet
, small-steps, small-steps-test, streaming, tasty, tasty-hedgehog
, text, time, vector
}:
mkDerivation {
  pname = "cardano-ledger-byron-test";
  version = "1.3.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-ledger/";
    sha256 = "0avzyiqq0m8njd41ck9kpn992yq676b1az9xs77977h7cf85y4wm";
    rev = "1a9ec4ae9e0b09d54e49b2a40c4ead37edadcce5";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/eras/byron/ledger/impl/test; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    base base16-bytestring bimap byron-spec-chain byron-spec-ledger
    bytestring cardano-binary cardano-binary-test cardano-crypto
    cardano-crypto-test cardano-crypto-wrapper cardano-ledger-byron
    cardano-prelude cardano-prelude-test containers directory filepath
    formatting generic-monoid hedgehog microlens resourcet small-steps
    small-steps-test streaming tasty tasty-hedgehog text time vector
  ];
  description = "Test helpers from cardano-ledger exposed to other packages";
  license = lib.licenses.asl20;
}
