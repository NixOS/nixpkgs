{ mkDerivation, base, containers, fetchgit, lib, plutus-core
, plutus-tx, plutus-tx-plugin, prettyprinter, template-haskell
, th-abstraction
}:
mkDerivation {
  pname = "plutus-errors";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/plutus/";
    sha256 = "1jicyk4hr8p0xksj4048gdxndrb42jz4wsnkhc3ymxbm5v6snalf";
    rev = "1efbb276ef1a10ca6961d0fd32e6141e9798bd11";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/plutus-errors; echo source root reset to $sourceRoot";
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    base containers plutus-core plutus-tx plutus-tx-plugin
    prettyprinter template-haskell th-abstraction
  ];
  executableHaskellDepends = [
    base containers plutus-core prettyprinter template-haskell
    th-abstraction
  ];
  description = "The error codes of the Plutus compiler & runtime";
  license = lib.licenses.asl20;
}
