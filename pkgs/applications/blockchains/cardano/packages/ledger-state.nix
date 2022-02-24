{ mkDerivation, base, bytestring, cardano-binary
, cardano-crypto-class, cardano-data, cardano-ledger-alonzo
, cardano-ledger-core, cardano-ledger-shelley
, cardano-ledger-shelley-ma, compact-map, conduit, containers
, deepseq, fetchgit, foldl, lib, optparse-applicative, persistent
, persistent-sqlite, prettyprinter, set-algebra, strict-containers
, text, transformers, vector, weigh
}:
mkDerivation {
  pname = "ledger-state";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-ledger/";
    sha256 = "0avzyiqq0m8njd41ck9kpn992yq676b1az9xs77977h7cf85y4wm";
    rev = "1a9ec4ae9e0b09d54e49b2a40c4ead37edadcce5";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/libs/ledger-state; echo source root reset to $sourceRoot";
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    base bytestring cardano-binary cardano-crypto-class cardano-data
    cardano-ledger-alonzo cardano-ledger-core cardano-ledger-shelley
    cardano-ledger-shelley-ma compact-map conduit containers deepseq
    foldl persistent persistent-sqlite prettyprinter set-algebra
    strict-containers text transformers vector
  ];
  executableHaskellDepends = [
    base cardano-ledger-shelley optparse-applicative text
  ];
  benchmarkHaskellDepends = [
    base deepseq optparse-applicative text weigh
  ];
  license = lib.licenses.asl20;
}
