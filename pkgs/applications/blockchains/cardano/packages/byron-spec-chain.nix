{ mkDerivation, base, bimap, byron-spec-ledger, bytestring
, cardano-data, containers, data-ordlist, fetchgit, goblins
, hashable, hedgehog, lib, microlens, microlens-th, small-steps
, small-steps-test, tasty, tasty-hedgehog, tasty-hunit
}:
mkDerivation {
  pname = "byron-spec-chain";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-ledger/";
    sha256 = "0avzyiqq0m8njd41ck9kpn992yq676b1az9xs77977h7cf85y4wm";
    rev = "1a9ec4ae9e0b09d54e49b2a40c4ead37edadcce5";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/eras/byron/chain/executable-spec; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    base bimap byron-spec-ledger bytestring cardano-data containers
    goblins hashable hedgehog microlens microlens-th small-steps
    small-steps-test
  ];
  testHaskellDepends = [
    base byron-spec-ledger cardano-data containers data-ordlist
    hedgehog microlens small-steps small-steps-test tasty
    tasty-hedgehog tasty-hunit
  ];
  homepage = "https://github.com/input-output-hk/cardano-legder-specs";
  description = "Executable specification of the Cardano blockchain";
  license = lib.licenses.asl20;
}
