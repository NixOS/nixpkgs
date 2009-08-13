a :  
let 
  fetchurl = a.fetchurl;

  version = a.lib.attrByPath ["version"] "2009.08.08" a; 
  buildInputs = with a; [
    pkgconfig webkit libsoup gtk makeWrapper
  ];
in
rec {
  src = fetchurl {
    url = "http://github.com/Dieterbe/uzbl/tarball/${version}";
    sha256 = "06f0ae1e34bc0b0f77feeba5f832cdc2349ac04cbc7a5a5b9e7e5ff086a9c497";
    name = "uzbl-master-${version}.tar.gz";
  };

  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be removed if not needed */
  phaseNames = ["doMakeInstall" "doWrap"];

  doWrap = a.makeManyWrappers "$out/bin/uzbl" 
    ''
      --prefix GST_PLUGIN_PATH : ${a.webkit.gstreamer}/lib/gstreamer-* \
      --prefix GST_PLUGIN_PATH : ${a.webkit.gstPluginsBase}/lib/gstreamer-* \
      --prefix GST_PLUGIN_PATH : ${a.webkit.gstPluginsGood}/lib/gstreamer-* \
      --prefix GST_PLUGIN_PATH : ${a.webkit.gstFfmpeg}/lib/gstreamer-* 
    '';

  installFlags = "PREFIX=$out";
      
  name = "uzbl-" + version;
  meta = {
    description = "Tiny externally controllable webkit browser";
    maintainers = [a.lib.maintainers.raskin];
  };
}
