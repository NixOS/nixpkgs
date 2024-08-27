{
  melpaBuild,
  haskell-mode,
  haskellPackages,
}:

let
  inherit (haskellPackages) hsc3;
in
melpaBuild {
  pname = "hsc3-mode";
  ename = "hsc3";
  inherit (hsc3) src version;

  files = ''("emacs/*.el")'';

  packageRequires = [ haskell-mode ];

  ignoreCompilationError = false;

  meta = {
    inherit (hsc3.meta) homepage license;
    description = "Emacs mode for hsc3";
  };
}
