{ mkDerivation, base, bech32, bytestring, cardano-crypto-class
, cardano-data, cardano-ledger-alonzo, cardano-ledger-byron
, cardano-ledger-core, cardano-ledger-shelley
, cardano-ledger-shelley-ma, cardano-protocol-tpraos
, cardano-slotting, compact-map, containers, fetchgit, iproute, lib
, mtl, plutus-ledger-api, prettyprinter, set-algebra, small-steps
, strict-containers, text
}:
mkDerivation {
  pname = "cardano-ledger-pretty";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-ledger/";
    sha256 = "0avzyiqq0m8njd41ck9kpn992yq676b1az9xs77977h7cf85y4wm";
    rev = "1a9ec4ae9e0b09d54e49b2a40c4ead37edadcce5";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/libs/cardano-ledger-pretty; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    base bech32 bytestring cardano-crypto-class cardano-data
    cardano-ledger-alonzo cardano-ledger-byron cardano-ledger-core
    cardano-ledger-shelley cardano-ledger-shelley-ma
    cardano-protocol-tpraos cardano-slotting compact-map containers
    iproute mtl plutus-ledger-api prettyprinter set-algebra small-steps
    strict-containers text
  ];
  license = lib.licenses.asl20;
}
