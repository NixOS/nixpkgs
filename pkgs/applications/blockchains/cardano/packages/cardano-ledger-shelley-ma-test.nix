{ mkDerivation, base, base16-bytestring, bytestring, cardano-binary
, cardano-crypto-class, cardano-data, cardano-ledger-core
, cardano-ledger-pretty, cardano-ledger-shelley
, cardano-ledger-shelley-ma, cardano-ledger-shelley-test
, cardano-slotting, cborg, containers, data-default-class, fetchgit
, generic-random, hashable, lib, mtl, QuickCheck, small-steps
, small-steps-test, strict-containers, tasty, tasty-hunit
, tasty-quickcheck, text
}:
mkDerivation {
  pname = "cardano-ledger-shelley-ma-test";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-ledger/";
    sha256 = "0avzyiqq0m8njd41ck9kpn992yq676b1az9xs77977h7cf85y4wm";
    rev = "1a9ec4ae9e0b09d54e49b2a40c4ead37edadcce5";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/eras/shelley-ma/test-suite; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    base base16-bytestring bytestring cardano-binary
    cardano-crypto-class cardano-data cardano-ledger-core
    cardano-ledger-pretty cardano-ledger-shelley
    cardano-ledger-shelley-ma cardano-ledger-shelley-test
    cardano-slotting cborg containers generic-random hashable mtl
    QuickCheck strict-containers tasty tasty-hunit tasty-quickcheck
    text
  ];
  testHaskellDepends = [
    base bytestring cardano-binary cardano-data cardano-ledger-core
    cardano-ledger-shelley cardano-ledger-shelley-ma
    cardano-ledger-shelley-test cardano-slotting cborg containers
    data-default-class mtl QuickCheck small-steps small-steps-test
    strict-containers tasty tasty-hunit tasty-quickcheck
  ];
  description = "Shelley ledger with multiasset and time lock support";
  license = lib.licenses.asl20;
}
