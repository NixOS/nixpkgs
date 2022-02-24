{ mkDerivation, aeson, aeson-pretty, base, bytestring, cardano-api
, cardano-crypto, cardano-ledger-core, containers, cryptonite
, data-default, deepseq, directory, extensible-effects, fetchgit
, filepath, fingertree, flat, foldl, freer-extras, freer-simple
, hashable, hedgehog, IntervalMap, lens, lib, memory, mmorph
, monad-control, mtl, newtype-generics, openapi3
, plutus-chain-index, plutus-core, plutus-ledger, plutus-ledger-api
, plutus-tx, plutus-tx-plugin, prettyprinter, profunctors
, QuickCheck, quickcheck-dynamic, random, row-types, semigroupoids
, semigroups, serialise, servant, streaming, tasty, tasty-golden
, tasty-hedgehog, tasty-hunit, tasty-quickcheck, template-haskell
, text, transformers, unordered-containers, uuid
}:
mkDerivation {
  pname = "plutus-contract";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/plutus/";
    sha256 = "1jicyk4hr8p0xksj4048gdxndrb42jz4wsnkhc3ymxbm5v6snalf";
    rev = "1efbb276ef1a10ca6961d0fd32e6141e9798bd11";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/plutus-contract; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    aeson aeson-pretty base bytestring cardano-api cardano-crypto
    cardano-ledger-core containers cryptonite data-default deepseq
    directory filepath fingertree flat foldl freer-extras freer-simple
    hashable hedgehog IntervalMap lens memory mmorph monad-control mtl
    newtype-generics openapi3 plutus-chain-index plutus-core
    plutus-ledger plutus-ledger-api plutus-tx plutus-tx-plugin
    prettyprinter profunctors QuickCheck quickcheck-dynamic random
    row-types semigroupoids semigroups serialise servant streaming
    tasty tasty-golden tasty-hunit template-haskell text transformers
    unordered-containers uuid
  ];
  testHaskellDepends = [
    aeson base bytestring containers data-default extensible-effects
    freer-extras freer-simple hedgehog lens mtl plutus-ledger plutus-tx
    plutus-tx-plugin semigroupoids tasty tasty-golden tasty-hedgehog
    tasty-hunit tasty-quickcheck text transformers
  ];
  homepage = "https://github.com/iohk/plutus#readme";
  license = lib.licenses.asl20;
}
