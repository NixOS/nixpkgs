{ mkDerivation, aeson, base, bytestring, cborg, containers
, deriving-aeson, extra, fetchgit, freer-simple, hedgehog
, http-client, inline-r, lens, lib, loch-th, marlowe, mtl
, newtype-generics, plutus-contract, plutus-ledger, plutus-tx
, QuickCheck, sbv, scientific, servant, servant-client
, servant-client-core, sort, tasty, tasty-hunit, template-haskell
, text, time, unordered-containers, utf8-string, validation, vector
, wl-pprint
}:
mkDerivation {
  pname = "marlowe-actus";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/plutus/";
    sha256 = "1jicyk4hr8p0xksj4048gdxndrb42jz4wsnkhc3ymxbm5v6snalf";
    rev = "1efbb276ef1a10ca6961d0fd32e6141e9798bd11";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/marlowe-actus; echo source root reset to $sourceRoot";
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson base bytestring containers marlowe mtl newtype-generics
    plutus-contract plutus-ledger plutus-tx sort template-haskell text
    time validation vector
  ];
  executableHaskellDepends = [
    aeson base bytestring containers deriving-aeson freer-simple
    http-client inline-r loch-th marlowe mtl newtype-generics
    plutus-contract plutus-ledger plutus-tx QuickCheck sbv servant
    servant-client servant-client-core sort template-haskell text time
    validation vector wl-pprint
  ];
  testHaskellDepends = [
    aeson base bytestring cborg containers extra hedgehog lens marlowe
    plutus-contract plutus-ledger plutus-tx scientific tasty
    tasty-hunit template-haskell text time unordered-containers
    utf8-string validation vector
  ];
  description = "Marlowe ACTUS: standardised financial contracts on Cardano Computation Layer";
  license = lib.licenses.asl20;
}
