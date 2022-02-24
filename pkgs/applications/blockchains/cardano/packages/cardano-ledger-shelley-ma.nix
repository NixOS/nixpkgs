{ mkDerivation, base, base16-bytestring, bytestring, cardano-binary
, cardano-crypto-class, cardano-data, cardano-ledger-core
, cardano-ledger-shelley, cardano-prelude, cardano-protocol-tpraos
, cardano-slotting, cborg, containers, data-default-class, deepseq
, fetchgit, groups, lib, mtl, nothunks, primitive, set-algebra
, small-steps, strict-containers, text, transformers
}:
mkDerivation {
  pname = "cardano-ledger-shelley-ma";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-ledger/";
    sha256 = "0avzyiqq0m8njd41ck9kpn992yq676b1az9xs77977h7cf85y4wm";
    rev = "1a9ec4ae9e0b09d54e49b2a40c4ead37edadcce5";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/eras/shelley-ma/impl; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    base base16-bytestring bytestring cardano-binary
    cardano-crypto-class cardano-data cardano-ledger-core
    cardano-ledger-shelley cardano-prelude cardano-protocol-tpraos
    cardano-slotting cborg containers data-default-class deepseq groups
    mtl nothunks primitive set-algebra small-steps strict-containers
    text transformers
  ];
  description = "Shelley ledger with multiasset and time lock support";
  license = lib.licenses.asl20;
}
