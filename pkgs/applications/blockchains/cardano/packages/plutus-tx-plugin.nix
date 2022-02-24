{ mkDerivation, base, bytestring, containers, deepseq, extra
, fetchgit, flat, ghc, ghc-prim, hedgehog, integer-gmp, lens, lib
, mtl, plutus-core, plutus-tx, prettyprinter, serialise, tasty
, tasty-hedgehog, tasty-hunit, template-haskell, text, transformers
}:
mkDerivation {
  pname = "plutus-tx-plugin";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/plutus/";
    sha256 = "1jicyk4hr8p0xksj4048gdxndrb42jz4wsnkhc3ymxbm5v6snalf";
    rev = "1efbb276ef1a10ca6961d0fd32e6141e9798bd11";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/plutus-tx-plugin; echo source root reset to $sourceRoot";
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    base bytestring containers extra flat ghc ghc-prim lens mtl
    plutus-core plutus-tx prettyprinter template-haskell text
    transformers
  ];
  executableHaskellDepends = [
    base bytestring deepseq flat integer-gmp lens mtl plutus-core
    plutus-tx prettyprinter serialise template-haskell text
  ];
  testHaskellDepends = [
    base bytestring deepseq flat ghc-prim hedgehog integer-gmp lens mtl
    plutus-core plutus-tx prettyprinter serialise tasty tasty-hedgehog
    tasty-hunit template-haskell text
  ];
  description = "The Plutus Tx compiler and GHC plugin";
  license = lib.licenses.asl20;
}
