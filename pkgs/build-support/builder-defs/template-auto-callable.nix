x@{builderDefsPackage
  (abort "Specify dependencies")
  , ...}:
builderDefsPackage
(a :  
let 
  s = import ./src-for-default.nix;
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [(abort "Specify helper argument names")];
  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
in
rec {
  src = a.fetchUrlFromSrcInfo s;

  inherit (s) name;
  inherit buildInputs;

  /* doConfigure should be removed if not needed */
  phaseNames = ["doConfigure" "doMakeInstall"];
      
  meta = {
    description = "${abort ''Specify description''}";
    maintainers = with a.lib.maintainers;
    [
      (abort "Specify maintainers")
    ];
    platforms = with a.lib.platforms;
      (abort "Specify platforms");
  };
}) x

