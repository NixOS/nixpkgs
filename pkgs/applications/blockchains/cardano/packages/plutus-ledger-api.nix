{ mkDerivation, aeson, base, base16-bytestring, bytestring, cborg
, containers, deepseq, fetchgit, flat, hashable, hedgehog, lens
, lib, memory, mtl, newtype-generics, plutus-core, plutus-tx
, prettyprinter, scientific, serialise, tagged, tasty
, tasty-hedgehog, tasty-hunit, template-haskell, text, transformers
}:
mkDerivation {
  pname = "plutus-ledger-api";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/plutus/";
    sha256 = "1jicyk4hr8p0xksj4048gdxndrb42jz4wsnkhc3ymxbm5v6snalf";
    rev = "1efbb276ef1a10ca6961d0fd32e6141e9798bd11";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/plutus-ledger-api; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    aeson base base16-bytestring bytestring cborg containers deepseq
    flat hashable lens memory mtl newtype-generics plutus-core
    plutus-tx prettyprinter scientific serialise tagged
    template-haskell text transformers
  ];
  testHaskellDepends = [
    aeson base hedgehog tasty tasty-hedgehog tasty-hunit
  ];
  description = "Interface to the Plutus ledger for the Cardano ledger";
  license = lib.licenses.asl20;
}
