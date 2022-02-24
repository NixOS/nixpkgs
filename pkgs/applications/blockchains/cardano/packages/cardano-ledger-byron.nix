{ mkDerivation, aeson, base, base16-bytestring, base58-bytestring
, bimap, binary, byron-spec-chain, byron-spec-ledger, bytestring
, Cabal, canonical-json, cardano-binary, cardano-binary-test
, cardano-crypto, cardano-crypto-test, cardano-crypto-wrapper
, cardano-prelude, cardano-prelude-test, cborg, containers
, contra-tracer, cryptonite, deepseq, digest, directory, fetchgit
, filepath, formatting, generic-monoid, hedgehog, lib, microlens
, mtl, nothunks, quiet, resourcet, small-steps, small-steps-test
, streaming, streaming-binary, streaming-bytestring, tasty
, tasty-hedgehog, text, time, vector
}:
mkDerivation {
  pname = "cardano-ledger-byron";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-ledger/";
    sha256 = "0avzyiqq0m8njd41ck9kpn992yq676b1az9xs77977h7cf85y4wm";
    rev = "1a9ec4ae9e0b09d54e49b2a40c4ead37edadcce5";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/eras/byron/ledger/impl; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    aeson base base58-bytestring bimap binary bytestring Cabal
    canonical-json cardano-binary cardano-crypto cardano-crypto-wrapper
    cardano-prelude cborg containers contra-tracer cryptonite deepseq
    digest directory filepath formatting mtl nothunks quiet resourcet
    streaming streaming-binary streaming-bytestring text time vector
  ];
  testHaskellDepends = [
    base base16-bytestring bimap byron-spec-chain byron-spec-ledger
    bytestring cardano-binary cardano-binary-test cardano-crypto
    cardano-crypto-test cardano-crypto-wrapper cardano-prelude
    cardano-prelude-test cborg containers directory filepath formatting
    generic-monoid hedgehog microlens resourcet small-steps
    small-steps-test streaming tasty tasty-hedgehog text time vector
  ];
  description = "The blockchain layer of Cardano during the Byron era";
  license = lib.licenses.asl20;
}
