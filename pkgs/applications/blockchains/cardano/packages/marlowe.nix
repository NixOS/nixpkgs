{ mkDerivation, aeson, async, base, bytestring, cborg, containers
, data-default, deriving-aeson, fetchgit, freer-extras
, freer-simple, hint, http-client, lens, lib, mtl, network
, newtype-generics, openapi3, plutus-chain-index, plutus-contract
, plutus-core, plutus-ledger, plutus-pab, plutus-tx
, plutus-tx-plugin, plutus-use-cases, prettyprinter
, purescript-bridge, QuickCheck, sbv, scientific, semigroups
, serialise, servant-client, streaming, tasty, tasty-hunit
, tasty-quickcheck, template-haskell, text, vector, websockets
, wl-pprint
}:
mkDerivation {
  pname = "marlowe";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/plutus/";
    sha256 = "1jicyk4hr8p0xksj4048gdxndrb42jz4wsnkhc3ymxbm5v6snalf";
    rev = "1efbb276ef1a10ca6961d0fd32e6141e9798bd11";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/marlowe; echo source root reset to $sourceRoot";
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson base bytestring containers data-default deriving-aeson
    freer-simple lens mtl newtype-generics plutus-chain-index
    plutus-contract plutus-core plutus-ledger plutus-tx
    plutus-tx-plugin plutus-use-cases sbv scientific semigroups
    template-haskell text vector wl-pprint
  ];
  executableHaskellDepends = [
    aeson base containers data-default freer-extras freer-simple
    openapi3 plutus-contract plutus-ledger plutus-pab plutus-tx
    plutus-tx-plugin prettyprinter purescript-bridge
  ];
  testHaskellDepends = [
    aeson async base bytestring cborg containers data-default
    freer-simple hint http-client lens network openapi3
    plutus-chain-index plutus-contract plutus-ledger plutus-pab
    plutus-tx prettyprinter purescript-bridge QuickCheck serialise
    servant-client streaming tasty tasty-hunit tasty-quickcheck
    template-haskell text websockets
  ];
  description = "Marlowe: financial contracts on Cardano Computation Layer";
  license = lib.licenses.asl20;
}
