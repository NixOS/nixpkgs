{ mkDerivation, base, cardano-binary, cardano-crypto-class
, containers, fetchgit, goblins, hedgehog, lib, microlens
, microlens-th, mtl, nothunks, QuickCheck, small-steps
, strict-containers, tasty, tasty-expected-failure, tasty-hedgehog
, tasty-hunit, tasty-quickcheck, transformers, Unique
}:
mkDerivation {
  pname = "small-steps-test";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-ledger/";
    sha256 = "0avzyiqq0m8njd41ck9kpn992yq676b1az9xs77977h7cf85y4wm";
    rev = "1a9ec4ae9e0b09d54e49b2a40c4ead37edadcce5";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/libs/small-steps-test; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    base goblins hedgehog microlens microlens-th mtl nothunks
    QuickCheck small-steps strict-containers tasty-hunit transformers
  ];
  testHaskellDepends = [
    base cardano-binary cardano-crypto-class containers hedgehog mtl
    QuickCheck small-steps tasty tasty-expected-failure tasty-hedgehog
    tasty-hunit tasty-quickcheck Unique
  ];
  homepage = "https://github.com/input-output-hk/cardano-legder-specs";
  description = "Small step semantics testing library";
  license = lib.licenses.asl20;
}
