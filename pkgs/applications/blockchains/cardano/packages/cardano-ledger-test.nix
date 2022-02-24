{ mkDerivation, aeson, array, base, bytestring, cardano-binary
, cardano-crypto-class, cardano-data, cardano-ledger-alonzo
, cardano-ledger-alonzo-test, cardano-ledger-core
, cardano-ledger-pretty, cardano-ledger-shelley
, cardano-ledger-shelley-ma, cardano-ledger-shelley-ma-test
, cardano-ledger-shelley-test, cardano-slotting, compact-map
, containers, criterion, data-default-class, deepseq, fetchgit
, genvalidity, genvalidity-scientific, lib, mtl, plutus-ledger-api
, QuickCheck, random, scientific, small-steps, small-steps-test
, strict-containers, tasty, tasty-hunit, tasty-quickcheck, time
, transformers
}:
mkDerivation {
  pname = "cardano-ledger-test";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-ledger/";
    sha256 = "0avzyiqq0m8njd41ck9kpn992yq676b1az9xs77977h7cf85y4wm";
    rev = "1a9ec4ae9e0b09d54e49b2a40c4ead37edadcce5";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/libs/cardano-ledger-test; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    aeson array base bytestring cardano-binary cardano-crypto-class
    cardano-ledger-alonzo cardano-ledger-alonzo-test
    cardano-ledger-core cardano-ledger-pretty cardano-ledger-shelley
    cardano-ledger-shelley-ma cardano-ledger-shelley-test
    cardano-slotting containers data-default-class genvalidity
    genvalidity-scientific mtl plutus-ledger-api QuickCheck scientific
    small-steps small-steps-test strict-containers tasty tasty-hunit
    tasty-quickcheck time transformers
  ];
  testHaskellDepends = [ base cardano-ledger-shelley-test tasty ];
  benchmarkHaskellDepends = [
    base bytestring cardano-binary cardano-crypto-class cardano-data
    cardano-ledger-alonzo cardano-ledger-alonzo-test
    cardano-ledger-core cardano-ledger-shelley
    cardano-ledger-shelley-ma cardano-ledger-shelley-ma-test
    cardano-ledger-shelley-test compact-map containers criterion
    data-default-class deepseq QuickCheck random small-steps
    small-steps-test tasty tasty-quickcheck
  ];
  description = "Testing harness, tests and benchmarks for Shelley style cardano ledgers";
  license = lib.licenses.asl20;
}
