a :  
let 
  fetchurl = a.fetchurl;

  version = a.lib.attrByPath ["version"] "2009.07.18" a; 
  buildInputs = with a; [
    pkgconfig webkit libsoup gtk makeWrapper
  ];
in
rec {
  src = fetchurl {
    url = "http://github.com/Dieterbe/uzbl/tarball/${version}";
    sha256 = "1bgx2pl3f4y20s43xpz62dx9pa80z38d0l6kzyzjbpzikih69vkw";
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
