{ mkDerivation, base, bytestring, cardano-ledger-alonzo, fetchgit
, flat, lib, plutus-core, plutus-ledger-api, plutus-tx
, plutus-tx-plugin, serialise, template-haskell
}:
mkDerivation {
  pname = "plutus-preprocessor";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-ledger/";
    sha256 = "0avzyiqq0m8njd41ck9kpn992yq676b1az9xs77977h7cf85y4wm";
    rev = "1a9ec4ae9e0b09d54e49b2a40c4ead37edadcce5";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/libs/plutus-preprocessor; echo source root reset to $sourceRoot";
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    base bytestring cardano-ledger-alonzo flat plutus-core
    plutus-ledger-api plutus-tx plutus-tx-plugin serialise
    template-haskell
  ];
  description = "A preproceesor for creating plutus scripts as bytestrings and equivalents";
  license = lib.licenses.asl20;
}
