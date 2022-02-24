{ mkDerivation, aeson, base, base16-bytestring, bytestring
, cardano-binary, cardano-crypto, cardano-crypto-class
, cardano-crypto-wrapper, cardano-data, cardano-ledger-byron
, cardano-ledger-core, cardano-prelude, cardano-protocol-tpraos
, cardano-slotting, cborg, compact-map, constraints, containers
, data-default-class, deepseq, fetchgit, groups, iproute, lib
, microlens, mtl, nothunks, primitive, quiet, set-algebra
, small-steps, strict-containers, text, time, transformers
}:
mkDerivation {
  pname = "cardano-ledger-shelley";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-ledger/";
    sha256 = "0avzyiqq0m8njd41ck9kpn992yq676b1az9xs77977h7cf85y4wm";
    rev = "1a9ec4ae9e0b09d54e49b2a40c4ead37edadcce5";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/eras/shelley/impl; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    aeson base base16-bytestring bytestring cardano-binary
    cardano-crypto cardano-crypto-class cardano-crypto-wrapper
    cardano-data cardano-ledger-byron cardano-ledger-core
    cardano-prelude cardano-protocol-tpraos cardano-slotting cborg
    compact-map constraints containers data-default-class deepseq
    groups iproute microlens mtl nothunks primitive quiet set-algebra
    small-steps strict-containers text time transformers
  ];
  license = lib.licenses.asl20;
}
