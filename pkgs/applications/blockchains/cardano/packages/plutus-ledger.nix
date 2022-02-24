{ mkDerivation, aeson, base, base16-bytestring, bytestring
, cardano-api, cardano-binary, cardano-crypto, cardano-crypto-class
, cborg, containers, cryptonite, data-default, deepseq, fetchgit
, flat, freer-extras, hashable, hedgehog, http-api-data, lens, lib
, memory, mtl, newtype-generics, openapi3, plutus-core
, plutus-ledger-api, plutus-tx, plutus-tx-plugin, prettyprinter
, recursion-schemes, scientific, serialise, tasty, tasty-hedgehog
, tasty-hunit, template-haskell, text, time, time-units
, transformers
}:
mkDerivation {
  pname = "plutus-ledger";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/plutus/";
    sha256 = "1jicyk4hr8p0xksj4048gdxndrb42jz4wsnkhc3ymxbm5v6snalf";
    rev = "1efbb276ef1a10ca6961d0fd32e6141e9798bd11";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/plutus-ledger; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    aeson base base16-bytestring bytestring cardano-api cardano-binary
    cardano-crypto cardano-crypto-class cborg containers cryptonite
    data-default deepseq flat freer-extras hashable hedgehog
    http-api-data lens memory mtl newtype-generics openapi3 plutus-core
    plutus-ledger-api plutus-tx plutus-tx-plugin prettyprinter
    recursion-schemes scientific serialise template-haskell text time
    time-units transformers
  ];
  testHaskellDepends = [
    aeson base bytestring containers data-default hedgehog lens
    plutus-core plutus-tx plutus-tx-plugin tasty tasty-hedgehog
    tasty-hunit transformers
  ];
  description = "Wallet API";
  license = lib.licenses.asl20;
}
