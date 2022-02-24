{ mkDerivation, array, base, bytestring, cardano-binary
, cardano-crypto-class, cardano-crypto-praos, cardano-ledger-core
, cardano-ledger-shelley, cardano-ledger-shelley-test
, cardano-prelude, cardano-protocol-tpraos, cardano-slotting, cborg
, containers, data-default-class, deepseq, fetchgit, generic-random
, groups, hashable, lib, mtl, nothunks, prettyprinter, primitive
, QuickCheck, small-steps, small-steps-test, strict-containers
, tasty, tasty-hunit, tasty-quickcheck, text, transformers
}:
mkDerivation {
  pname = "cardano-ledger-example-shelley";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-ledger/";
    sha256 = "0avzyiqq0m8njd41ck9kpn992yq676b1az9xs77977h7cf85y4wm";
    rev = "1a9ec4ae9e0b09d54e49b2a40c4ead37edadcce5";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/libs/cardano-ledger-example-shelley; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    array base bytestring cardano-binary cardano-crypto-class
    cardano-crypto-praos cardano-ledger-core cardano-ledger-shelley
    cardano-ledger-shelley-test cardano-prelude cardano-protocol-tpraos
    cardano-slotting cborg containers data-default-class deepseq
    generic-random groups hashable mtl nothunks prettyprinter primitive
    QuickCheck small-steps strict-containers tasty tasty-hunit
    tasty-quickcheck text transformers
  ];
  testHaskellDepends = [
    base bytestring cardano-binary cardano-crypto-class
    cardano-ledger-core cardano-ledger-shelley
    cardano-ledger-shelley-test cardano-prelude cardano-slotting cborg
    containers data-default-class generic-random mtl QuickCheck
    small-steps small-steps-test strict-containers tasty tasty-hunit
    tasty-quickcheck
  ];
  doHaddock = false;
  description = "Example era within Shelley context";
  license = lib.licenses.asl20;
}
