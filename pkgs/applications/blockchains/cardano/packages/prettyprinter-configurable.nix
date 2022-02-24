{ mkDerivation, base, Cabal, cabal-doctest, doctest, fetchgit, lib
, megaparsec, microlens, mtl, parser-combinators, prettyprinter
, QuickCheck, quickcheck-text, tasty, tasty-hunit, tasty-quickcheck
, text
}:
mkDerivation {
  pname = "prettyprinter-configurable";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/plutus/";
    sha256 = "1jicyk4hr8p0xksj4048gdxndrb42jz4wsnkhc3ymxbm5v6snalf";
    rev = "1efbb276ef1a10ca6961d0fd32e6141e9798bd11";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/prettyprinter-configurable; echo source root reset to $sourceRoot";
  setupHaskellDepends = [ base Cabal cabal-doctest ];
  libraryHaskellDepends = [ base microlens mtl prettyprinter text ];
  testHaskellDepends = [
    base doctest megaparsec parser-combinators prettyprinter QuickCheck
    quickcheck-text tasty tasty-hunit tasty-quickcheck text
  ];
  license = "unknown";
  hydraPlatforms = lib.platforms.none;
}
