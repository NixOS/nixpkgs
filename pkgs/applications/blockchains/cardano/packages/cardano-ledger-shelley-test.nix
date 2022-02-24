{ mkDerivation, aeson, base, base16-bytestring, binary, bytestring
, cardano-binary, cardano-crypto, cardano-crypto-class
, cardano-crypto-praos, cardano-crypto-test, cardano-crypto-wrapper
, cardano-data, cardano-ledger-byron, cardano-ledger-byron-test
, cardano-ledger-core, cardano-ledger-pretty
, cardano-ledger-shelley, cardano-prelude, cardano-prelude-test
, cardano-protocol-tpraos, cardano-slotting, cborg, compact-map
, containers, criterion, data-default-class, deepseq, directory
, fetchgit, generic-random, groups, hashable, hedgehog
, hedgehog-quickcheck, iproute, lib, mtl, nothunks
, plutus-ledger-api, prettyprinter, process-extras, QuickCheck
, scientific, serialise, set-algebra, small-steps, small-steps-test
, strict-containers, tasty, tasty-hedgehog, tasty-hunit
, tasty-quickcheck, text, time, transformers, tree-diff, vector
}:
mkDerivation {
  pname = "cardano-ledger-shelley-test";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-ledger/";
    sha256 = "0avzyiqq0m8njd41ck9kpn992yq676b1az9xs77977h7cf85y4wm";
    rev = "1a9ec4ae9e0b09d54e49b2a40c4ead37edadcce5";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/eras/shelley/test-suite; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    base base16-bytestring bytestring cardano-binary cardano-crypto
    cardano-crypto-class cardano-crypto-test cardano-crypto-wrapper
    cardano-ledger-byron cardano-ledger-byron-test cardano-ledger-core
    cardano-ledger-pretty cardano-ledger-shelley cardano-prelude
    cardano-prelude-test cardano-protocol-tpraos cardano-slotting cborg
    compact-map containers data-default-class deepseq directory
    generic-random hashable hedgehog hedgehog-quickcheck iproute mtl
    nothunks plutus-ledger-api process-extras QuickCheck serialise
    set-algebra small-steps small-steps-test strict-containers tasty
    tasty-hunit tasty-quickcheck text time transformers tree-diff
    vector
  ];
  testHaskellDepends = [
    aeson base base16-bytestring binary bytestring cardano-binary
    cardano-crypto-class cardano-crypto-praos cardano-data
    cardano-ledger-byron cardano-ledger-core cardano-ledger-pretty
    cardano-ledger-shelley cardano-prelude cardano-prelude-test
    cardano-protocol-tpraos cardano-slotting cborg compact-map
    containers data-default-class groups hedgehog iproute prettyprinter
    QuickCheck scientific set-algebra small-steps small-steps-test
    strict-containers tasty tasty-hedgehog tasty-hunit tasty-quickcheck
    time transformers
  ];
  benchmarkHaskellDepends = [
    base cardano-crypto-class cardano-crypto-praos cardano-data
    cardano-ledger-core cardano-ledger-shelley cardano-prelude
    cardano-protocol-tpraos cardano-slotting containers criterion
    data-default-class deepseq mtl QuickCheck set-algebra small-steps
    small-steps-test strict-containers transformers
  ];
  license = lib.licenses.asl20;
}
