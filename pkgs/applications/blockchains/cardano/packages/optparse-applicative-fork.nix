{ mkDerivation, ansi-terminal, base, fetchgit, lib, prettyprinter
, process, QuickCheck, text, transformers, transformers-compat
}:
mkDerivation {
  pname = "optparse-applicative-fork";
  version = "0.16.1.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/optparse-applicative/";
    sha256 = "1gvsrg925vynwgqwplgjmp53vj953qyh3wbdf34pw21c8r47w35r";
    rev = "7497a29cb998721a9068d5725d49461f2bba0e7a";
    fetchSubmodules = true;
  };
  libraryHaskellDepends = [
    ansi-terminal base prettyprinter process text transformers
    transformers-compat
  ];
  testHaskellDepends = [ base QuickCheck ];
  homepage = "https://github.com/pcapriotti/optparse-applicative-fork";
  description = "Utilities and combinators for parsing command line options";
  license = lib.licenses.bsd3;
}
