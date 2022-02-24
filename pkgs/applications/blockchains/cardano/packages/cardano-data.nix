{ mkDerivation, base, bytestring, cardano-binary
, cardano-crypto-class, cborg, compact-map, containers, cryptonite
, deepseq, fetchgit, formatting, lib, microlens, mtl, nothunks
, primitive, strict-containers, text, transformers
}:
mkDerivation {
  pname = "cardano-data";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-ledger/";
    sha256 = "0avzyiqq0m8njd41ck9kpn992yq676b1az9xs77977h7cf85y4wm";
    rev = "1a9ec4ae9e0b09d54e49b2a40c4ead37edadcce5";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/libs/cardano-data; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    base bytestring cardano-binary cardano-crypto-class cborg
    compact-map containers cryptonite deepseq formatting microlens mtl
    nothunks primitive strict-containers text transformers
  ];
  homepage = "https://github.com/input-output-hk/cardano-legder-specs";
  description = "Specialized data for Cardano project";
  license = lib.licenses.asl20;
}
