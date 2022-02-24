{ mkDerivation, aeson, base, base16-bytestring, binary, bytestring
, cardano-binary, cardano-crypto-class, cardano-crypto-praos
, cardano-crypto-wrapper, cardano-data, cardano-ledger-byron
, cardano-prelude, cardano-slotting, compact-map, containers
, data-default-class, deepseq, fetchgit, groups, iproute, lib, mtl
, network, non-integral, nothunks, partial-order, primitive, quiet
, scientific, small-steps, strict-containers, text, time
, transformers
}:
mkDerivation {
  pname = "cardano-ledger-core";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-ledger/";
    sha256 = "0avzyiqq0m8njd41ck9kpn992yq676b1az9xs77977h7cf85y4wm";
    rev = "1a9ec4ae9e0b09d54e49b2a40c4ead37edadcce5";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/libs/cardano-ledger-core; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    aeson base base16-bytestring binary bytestring cardano-binary
    cardano-crypto-class cardano-crypto-praos cardano-crypto-wrapper
    cardano-data cardano-ledger-byron cardano-prelude cardano-slotting
    compact-map containers data-default-class deepseq groups iproute
    mtl network non-integral nothunks partial-order primitive quiet
    scientific small-steps strict-containers text time transformers
  ];
  description = "Core components of Cardano ledgers from the Shelley release on";
  license = lib.licenses.asl20;
}
