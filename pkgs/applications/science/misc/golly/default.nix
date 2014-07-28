x@{builderDefsPackage,
  wxGTK, perl, python, zlib
  , ...}:
builderDefsPackage
(a :
let
  s = import ./src-for-default.nix;
  helperArgNames = ["builderDefsPackage"] ++
    [];
  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
in
rec {
  src = a.fetchUrlFromSrcInfo s;

  inherit (s) name;
  inherit buildInputs;

  /* doConfigure should be removed if not needed */
  phaseNames = ["setVars" "doConfigure" "doMakeInstall"];
  setVars = a.noDepEntry ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -lperl -L$(echo "${perl}"/lib/perl5/5*/*/CORE)"
    pythonLib="$(echo "${python}"/lib/libpython*.so)"
    pythonLib="''${pythonLib##*/lib}"
    pythonLib="''${pythonLib%%.so}"
    export NIX_LDFLAGS="$NIX_LDFLAGS -l$pythonLib"
    echo "Flags: $NIX_LDFLAGS"
  '';

  meta = {
    description = "Cellular automata simulation program";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = with a.lib.licenses;
      gpl2;
  };
}) x
