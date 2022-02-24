{ mkDerivation, base, base16-bytestring, bytestring, cardano-binary
, cardano-ledger-alonzo, cardano-ledger-core, cardano-ledger-pretty
, cardano-ledger-shelley, cardano-ledger-shelley-ma
, cardano-ledger-shelley-ma-test, cardano-ledger-shelley-test
, cardano-protocol-tpraos, cardano-slotting, containers
, data-default-class, fetchgit, hashable, lib, plutus-core
, plutus-ledger-api, plutus-tx, QuickCheck, set-algebra
, small-steps, small-steps-test, strict-containers, tasty
, tasty-hunit, tasty-quickcheck, text, time, transformers
}:
mkDerivation {
  pname = "cardano-ledger-alonzo-test";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-ledger/";
    sha256 = "0avzyiqq0m8njd41ck9kpn992yq676b1az9xs77977h7cf85y4wm";
    rev = "1a9ec4ae9e0b09d54e49b2a40c4ead37edadcce5";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/eras/alonzo/test-suite; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    base bytestring cardano-binary cardano-ledger-alonzo
    cardano-ledger-core cardano-ledger-pretty cardano-ledger-shelley
    cardano-ledger-shelley-ma cardano-ledger-shelley-ma-test
    cardano-ledger-shelley-test cardano-protocol-tpraos
    cardano-slotting containers data-default-class hashable
    plutus-ledger-api plutus-tx QuickCheck set-algebra
    strict-containers text
  ];
  testHaskellDepends = [
    base base16-bytestring bytestring cardano-binary
    cardano-ledger-alonzo cardano-ledger-core cardano-ledger-pretty
    cardano-ledger-shelley cardano-ledger-shelley-ma
    cardano-ledger-shelley-ma-test cardano-ledger-shelley-test
    cardano-protocol-tpraos cardano-slotting containers
    data-default-class plutus-core plutus-ledger-api plutus-tx
    QuickCheck small-steps small-steps-test strict-containers tasty
    tasty-hunit tasty-quickcheck time transformers
  ];
  description = "Tests for Cardano ledger introducing Plutus Core";
  license = lib.licenses.asl20;
}
