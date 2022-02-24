{ mkDerivation, aeson, aeson-pretty, base, bytestring, cardano-api
, cardano-binary, cardano-crypto-class, cborg, containers
, data-default, directory, fetchgit, filepath, flat, foldl
, freer-extras, freer-simple, hashable, hedgehog, lens, lib, memory
, mtl, openapi3, optparse-applicative, playground-common
, plutus-chain-index, plutus-contract, plutus-core, plutus-ledger
, plutus-ledger-api, plutus-tx, plutus-tx-plugin, prettyprinter
, QuickCheck, row-types, semigroups, serialise, streaming, tasty
, tasty-golden, tasty-hedgehog, tasty-hunit, tasty-quickcheck
, template-haskell, text
}:
mkDerivation {
  pname = "plutus-use-cases";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/plutus/";
    sha256 = "1jicyk4hr8p0xksj4048gdxndrb42jz4wsnkhc3ymxbm5v6snalf";
    rev = "1efbb276ef1a10ca6961d0fd32e6141e9798bd11";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/plutus-use-cases; echo source root reset to $sourceRoot";
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson base bytestring containers data-default freer-extras
    freer-simple hashable lens mtl openapi3 playground-common
    plutus-contract plutus-core plutus-ledger plutus-tx
    plutus-tx-plugin prettyprinter semigroups streaming
    template-haskell text
  ];
  executableHaskellDepends = [
    aeson aeson-pretty base bytestring cardano-api cardano-binary
    cardano-crypto-class cborg containers data-default directory
    filepath flat foldl freer-extras freer-simple hedgehog lens memory
    mtl optparse-applicative plutus-chain-index plutus-contract
    plutus-core plutus-ledger plutus-ledger-api plutus-tx
    plutus-tx-plugin prettyprinter QuickCheck row-types serialise
    streaming tasty tasty-golden tasty-hunit tasty-quickcheck text
  ];
  testHaskellDepends = [
    base bytestring cardano-crypto-class containers data-default foldl
    freer-extras freer-simple lens mtl plutus-contract plutus-ledger
    plutus-tx plutus-tx-plugin prettyprinter QuickCheck streaming tasty
    tasty-golden tasty-hedgehog tasty-hunit tasty-quickcheck text
  ];
  description = "Collection of smart contracts to develop the plutus/wallet interface";
  license = lib.licenses.asl20;
}
