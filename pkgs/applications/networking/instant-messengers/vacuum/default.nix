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
    version="1.1.1";
    baseName="vacuum-im";
    name="${baseName}-${version}";
    url="http://vacuum-im.googlecode.com/files/${name}.tar.xz";
    hash="b4b3472bf83173f6be1bbe69520bf6cab97e24cf9fd8a7b60e4ffdc1cb43b1dc";
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
  phaseNames = ["addInputs" "preBuild" "doQMake" "doMakeInstall"];

  preBuild = a.fullDepEntry (''
    echo "Fixing a name collision with a function added in Qt 4.7"
    sed -re 's/qHash[(][a-z ]*QUrl/vacuum_obsolete_&/' -i src/plugins/dataforms/dataforms.cpp
  '') ["minInit" "doUnpack"];

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
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://code.google.com/p/vacuum-im/downloads/list?can=2&q=&colspec=Filename";
    };
  };
}) x

