a :  
let 
  fetchurl = a.fetchurl;

  version = a.lib.attrByPath ["version"] "1.12.0" a; 
  buildInputs = with a; [
    firefox libX11 xproto
  ];
in
rec {
  src = fetchurl {
    url = "http://mozplugger.mozdev.org/files/mozplugger-${version}.tar.gz";
    sha256 = "1vpggfmbv4h3srk80rgidd020i03hrkpb7cfxkwagkcd0zcal4hk";
  };

  inherit buildInputs;
  configureFlags = [];
  makeFlags = ["linux" "prefix=" "root=$out"];

  preBuild = a.fullDepEntry(''
    sed -e s@/usr/@"$out/"@g -i mozplugger.c
  '') ["doUnpack" "minInit"];

  postInstall = a.fullDepEntry(''
    mkdir -p $out/share/${name}/plugin
    ln -s $out/lib/mozilla/plugins/mozplugger.so $out/share/${name}/plugin
  '') ["doMakeInstall" "minInit" "defEnsureDir"];

  /* doConfigure should be removed if not needed */
  phaseNames = ["preBuild" "doMakeInstall" "postInstall"];
      
  name = "mozplugger-" + version;
  meta = {
    description = "Mozilla plugin for launching external program for handling in-page objects";
  };
}
