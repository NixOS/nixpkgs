x@{builderDefsPackage
  , ncurses
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="vifm";
    version="0.6.3";
    name="${baseName}-${version}";
    url="mirror://sourceforge/project/${baseName}/${baseName}/${name}.tar.bz2";
    hash="1v5kiifjk7iyqrzjd94wn6a5dz4j3krl06pbp1ps9g3zdq2w2skv";
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
    description = "A vi-like file manager";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = a.lib.licenses.gpl2;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://vifm.sf.net";
    };
  };
}) x

