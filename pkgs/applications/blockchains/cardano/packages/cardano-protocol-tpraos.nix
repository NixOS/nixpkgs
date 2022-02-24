{ mkDerivation, base, bytestring, cardano-binary
, cardano-crypto-class, cardano-ledger-core, cardano-slotting
, containers, deepseq, fetchgit, lib, mtl, non-integral, nothunks
, quiet, set-algebra, small-steps, transformers
}:
mkDerivation {
  pname = "cardano-protocol-tpraos";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-ledger/";
    sha256 = "0avzyiqq0m8njd41ck9kpn992yq676b1az9xs77977h7cf85y4wm";
    rev = "1a9ec4ae9e0b09d54e49b2a40c4ead37edadcce5";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/libs/cardano-protocol-tpraos; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    base bytestring cardano-binary cardano-crypto-class
    cardano-ledger-core cardano-slotting containers deepseq mtl
    non-integral nothunks quiet set-algebra small-steps transformers
  ];
  license = lib.licenses.asl20;
}
