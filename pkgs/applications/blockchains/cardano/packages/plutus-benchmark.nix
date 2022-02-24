{ mkDerivation, ansi-wl-pprint, base, bytestring, containers
, criterion, deepseq, directory, fetchgit, filepath, flat, lib, mtl
, optparse-applicative, plutus-core, plutus-tx, plutus-tx-plugin
, serialise, tasty, tasty-hunit, tasty-quickcheck, text
, transformers
}:
mkDerivation {
  pname = "plutus-benchmark";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/plutus/";
    sha256 = "1jicyk4hr8p0xksj4048gdxndrb42jz4wsnkhc3ymxbm5v6snalf";
    rev = "1efbb276ef1a10ca6961d0fd32e6141e9798bd11";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/plutus-benchmark; echo source root reset to $sourceRoot";
  isLibrary = true;
  isExecutable = true;
  enableSeparateDataOutput = true;
  libraryHaskellDepends = [
    base deepseq plutus-core plutus-tx plutus-tx-plugin
  ];
  executableHaskellDepends = [
    ansi-wl-pprint base bytestring containers flat optparse-applicative
    plutus-core plutus-tx plutus-tx-plugin serialise transformers
  ];
  testHaskellDepends = [
    base containers mtl plutus-core plutus-tx plutus-tx-plugin tasty
    tasty-hunit tasty-quickcheck
  ];
  benchmarkHaskellDepends = [
    base bytestring containers criterion deepseq directory filepath
    flat mtl optparse-applicative plutus-core plutus-tx
    plutus-tx-plugin text transformers
  ];
  homepage = "https://github.com/iohk/plutus#readme";
  license = lib.licenses.asl20;
}
