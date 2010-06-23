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
  phaseNames = ["setVars" "doMake" "doDeploy"];
  setVars = a.noDepEntry ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -lperl -L$(echo "${perl}"/lib/perl5/5*/*/CORE)"
    pythonLib="$(echo "${python}"/lib/libpython*.so)"
    pythonLib="''${pythonLib##*/lib}"
    pythonLib="''${pythonLib%%.so}"
    export NIX_LDFLAGS="$NIX_LDFLAGS -l$pythonLib"
    echo "Flags: $NIX_LDFLAGS"
  '';
  goSrcDir = ''cd */'';
  makeFlags = [
    "-f makefile-gtk"
    ];
  doDeploy = a.fullDepEntry ''
    cat < ${./make-install.make}  >> makefile-gtk
    make -f makefile-gtk out="$out" install
  '' ["minInit" "doMake" "defEnsureDir"];
      
  meta = {
    description = "Cellular automata simulation program";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
  };
}) x

