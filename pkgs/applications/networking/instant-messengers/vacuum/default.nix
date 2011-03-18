x@{builderDefsPackage
  , qt4, openssl
  , xproto, libX11, libXScrnSaver, scrnsaverproto
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    version="1.1.0";
    baseName="vacuum";
    name="${baseName}-${version}";
    url="http://vacuum-im.googlecode.com/files/${name}.tar.gz";
    hash="c956b0cf5cc0a1acee47a96f0b0e7ab5d716e48cac4a7fcbca496f901a219dcc";
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
  phaseNames = ["preBuild" "doQMake" "doMakeInstall"];

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

