{ mkDerivation, aeson, base, bytestring, cborg, containers, deepseq
, doctest, fetchgit, flat, ghc-prim, hashable, hedgehog, lens, lib
, memory, mtl, plutus-core, prettyprinter, serialise, tasty
, tasty-hedgehog, tasty-hunit, template-haskell, text
, th-abstraction
}:
mkDerivation {
  pname = "plutus-tx";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/plutus/";
    sha256 = "1jicyk4hr8p0xksj4048gdxndrb42jz4wsnkhc3ymxbm5v6snalf";
    rev = "1efbb276ef1a10ca6961d0fd32e6141e9798bd11";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/plutus-tx; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    aeson base bytestring containers deepseq flat ghc-prim hashable
    lens memory mtl plutus-core prettyprinter serialise
    template-haskell text th-abstraction
  ];
  testHaskellDepends = [
    base bytestring cborg hedgehog plutus-core serialise tasty
    tasty-hedgehog tasty-hunit
  ];
  testToolDepends = [ doctest ];
  description = "Libraries for Plutus Tx and its prelude";
  license = lib.licenses.asl20;
}
