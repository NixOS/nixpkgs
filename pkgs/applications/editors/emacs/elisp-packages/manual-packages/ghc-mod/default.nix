{ lib
, melpaBuild
, haskell-mode
, haskellPackages
, writeText
}:

melpaBuild {
  pname = "ghc";

  inherit (haskellPackages.ghc-mod) version src;

  packageRequires = [ haskell-mode ];

  propagatedUserEnvPkgs = [ haskellPackages.ghc-mod ];

  recipe = writeText "recipe" ''
    (ghc-mod :repo "DanielG/ghc-mod" :fetcher github :files ("elisp/*.el"))
  '';

  meta = {
    description = "Extension of haskell-mode that provides completion of symbols and documentation browsing";
    license = lib.licenses.bsd3;
  };
}
