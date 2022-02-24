{ mkDerivation, aeson, base, containers, data-default-class
, fetchgit, free, lib, mtl, nothunks, strict-containers, text
, transformers
}:
mkDerivation {
  pname = "small-steps";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-ledger/";
    sha256 = "0avzyiqq0m8njd41ck9kpn992yq676b1az9xs77977h7cf85y4wm";
    rev = "1a9ec4ae9e0b09d54e49b2a40c4ead37edadcce5";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/libs/small-steps; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    aeson base containers data-default-class free mtl nothunks
    strict-containers text transformers
  ];
  homepage = "https://github.com/input-output-hk/cardano-legder-specs";
  description = "Small step semantics";
  license = lib.licenses.asl20;
}
