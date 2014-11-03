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
    version="1.2.4";
    baseName="vacuum-im";
    name="${baseName}-${version}";
    url="https://googledrive.com/host/0B7A5K_290X8-d1hjQmJaSGZmTTA/vacuum-1.2.4.tar.gz";
    sha256="10qxpfbbaagqcalhk0nagvi5irbbz5hk31w19lba8hxf6pfylrhf";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.sha256;
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

