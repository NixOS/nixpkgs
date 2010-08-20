x@{builderDefsPackage
  (abort "Specify dependencies")
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [(abort "Specify helper argument names")];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = {
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.hash;
  };

  inherit (sourceInfo) name version;
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
  passthru = {
    updateInfo = {
      downloadPage = "${abort ''Specify download page''}";
    };
  };
}) x

