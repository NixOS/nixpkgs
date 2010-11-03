x@{builderDefsPackage
  , libX11, gtk, pkgconfig, libXmu
  , libXpm, libpng, libjpeg, libtiff, librsvg
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="fbpanel";
    version="6.1";
    name="${baseName}-${version}";
    url="mirror://sourceforge/${baseName}/${name}.tbz2";
    hash="e14542cc81ea06e64dd4708546f5fd3f5e01884c3e4617885c7ef22af8cf3965";
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
  phaseNames = ["setVars" "doUnpack" "fixPaths" "doConfigure" "doMakeInstall"];

  fixPaths=(a.doPatchShebangs ".");
  setVars = a.fullDepEntry ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -lX11"
  '' [];
      
  meta = {
    description = "${abort ''Specify description''}";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
  };
  passthru = {
    updateInfo = {
      downloadPage = "fbpanel.sourceforge.net";
    };
  };
}) x

