x@{builderDefsPackage
  , qt4, openssl
  , xproto, libX11, libXScrnSaver, scrnsaverproto
  , xz
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    version="1.2.0";
    baseName="vacuum-im";
    name="${baseName}-${version}";
    url="http://vacuum-im.googlecode.com/files/vacuum-${version}.tar.xz";
    hash="55a2c27aaaf79c7a4de127c22d3845ede35970283d35ee57fd5ceca581b085fc";
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
  phaseNames = ["addInputs" "doQMake" "doMakeInstall"];

  doQMake = a.fullDepEntry (''
    qmake INSTALL_PREFIX=$out -recursive vacuum.pro
  '') ["doUnpack" "addInputs"];
      
  meta = {
    description = "An XMPP client fully composed of plugins";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = with a.lib.licenses;
      gpl3;
    homepage = "http://code.google.com/p/vacuum-im/";
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://code.google.com/p/vacuum-im/downloads/list?can=2&q=&colspec=Filename";
    };
  };
}) x

