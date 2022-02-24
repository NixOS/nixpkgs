{ mkDerivation, base, bytestring, Cabal, cryptonite, directory
, extra, fetchgit, ieee754, lazy-search, lib, memory, mtl
, optparse-applicative, plutus-core, process, size-based, Stream
, tasty, tasty-hunit, text, transformers, turtle
}:
mkDerivation {
  pname = "plutus-metatheory";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/plutus/";
    sha256 = "1jicyk4hr8p0xksj4048gdxndrb42jz4wsnkhc3ymxbm5v6snalf";
    rev = "1efbb276ef1a10ca6961d0fd32e6141e9798bd11";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/plutus-metatheory; echo source root reset to $sourceRoot";
  isLibrary = true;
  isExecutable = true;
  setupHaskellDepends = [ base Cabal process turtle ];
  libraryHaskellDepends = [
    base bytestring cryptonite extra ieee754 memory
    optparse-applicative plutus-core process text transformers
  ];
  executableHaskellDepends = [ base ];
  testHaskellDepends = [
    base bytestring Cabal directory lazy-search mtl plutus-core process
    size-based Stream tasty tasty-hunit text
  ];
  testToolDepends = [ plutus-core ];
  homepage = "https://github.com/input-output-hk/plutus";
  description = "Command line tool for running plutus core programs";
  license = lib.licenses.asl20;
}
