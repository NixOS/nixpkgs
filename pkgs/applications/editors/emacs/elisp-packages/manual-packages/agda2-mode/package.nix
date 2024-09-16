{ melpaBuild, haskellPackages }:
let
  Agda = haskellPackages.Agda;
in
melpaBuild {
  pname = "agda2-mode";
  inherit (Agda) src version;

  files = ''("src/data/emacs-mode/*.el")'';

  ignoreCompilationError = false;

  meta = {
    inherit (Agda.meta) homepage license;
    description = "Agda2-mode for Emacs extracted from Agda package";
  };
}
