x@{builderDefsPackage
  , libX11, xproto
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="stalonetray";
    version="0.8.0";
    name="${baseName}-${version}";
    url="mirror://sourceforge/${baseName}/${name}.tar.bz2";
    hash="0ccllmpsmilns6xxl174vgcjf8kfakcrhg3psc4cg0yynqbi2mka";
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
    description = "Stand alone tray";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://sourceforge.net/projects/stalonetray/files/";
    };
  };
}) x

