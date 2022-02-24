{ mkDerivation, array, base, base-deriving-via, base64-bytestring
, bytestring, cardano-binary, cardano-crypto-class, cardano-data
, cardano-ledger-core, cardano-ledger-shelley
, cardano-ledger-shelley-ma, cardano-prelude, cardano-slotting
, containers, data-default, deepseq, fetchgit, lib, measures, mtl
, nothunks, plutus-core, plutus-ledger-api, plutus-tx
, prettyprinter, serialise, set-algebra, small-steps
, strict-containers, text, time, transformers, utf8-string
}:
mkDerivation {
  pname = "cardano-ledger-alonzo";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-ledger/";
    sha256 = "0avzyiqq0m8njd41ck9kpn992yq676b1az9xs77977h7cf85y4wm";
    rev = "1a9ec4ae9e0b09d54e49b2a40c4ead37edadcce5";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/eras/alonzo/impl; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    array base base-deriving-via base64-bytestring bytestring
    cardano-binary cardano-crypto-class cardano-data
    cardano-ledger-core cardano-ledger-shelley
    cardano-ledger-shelley-ma cardano-prelude cardano-slotting
    containers data-default deepseq measures mtl nothunks plutus-core
    plutus-ledger-api plutus-tx prettyprinter serialise set-algebra
    small-steps strict-containers text time transformers utf8-string
  ];
  description = "Cardano ledger introducing Plutus Core";
  license = lib.licenses.asl20;
}
