{ mkDerivation, base, bimap, cardano-binary, cardano-data
, containers, fetchgit, filepath, goblins, hashable, hedgehog, lib
, microlens, microlens-th, nothunks, small-steps, small-steps-test
, tasty, tasty-hedgehog, tasty-hunit, template-haskell, Unique
}:
mkDerivation {
  pname = "byron-spec-ledger";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-ledger/";
    sha256 = "0avzyiqq0m8njd41ck9kpn992yq676b1az9xs77977h7cf85y4wm";
    rev = "1a9ec4ae9e0b09d54e49b2a40c4ead37edadcce5";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/eras/byron/ledger/executable-spec; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    base bimap cardano-binary cardano-data containers filepath goblins
    hashable hedgehog microlens microlens-th nothunks small-steps
    small-steps-test template-haskell Unique
  ];
  testHaskellDepends = [
    base bimap cardano-data containers hedgehog microlens microlens-th
    small-steps small-steps-test tasty tasty-hedgehog tasty-hunit
    Unique
  ];
  homepage = "https://github.com/input-output-hk/cardano-legder-specs";
  description = "Executable specification of Cardano ledger";
  license = lib.licenses.asl20;
}
