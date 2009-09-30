a :  
let 
  s = import ./src-for-experimental.nix;
  buildInputs = with a; [
    libsoup pkgconfig webkit gtk makeWrapper
  ];
in
rec {
  src = (a.fetchGitFromSrcInfo s) + "/";

  inherit (s) name;
  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be removed if not needed */
  phaseNames = ["addInputs" "doMakeInstall" "doWrap"];
      
  doWrap = a.makeManyWrappers "$out/bin/uzbl*" 
    ''
      --prefix GST_PLUGIN_PATH : ${a.webkit.gstreamer}/lib/gstreamer-* \
      --prefix GST_PLUGIN_PATH : ${a.webkit.gstPluginsBase}/lib/gstreamer-* \
      --prefix GST_PLUGIN_PATH : ${a.webkit.gstPluginsGood}/lib/gstreamer-* \
      --prefix GST_PLUGIN_PATH : ${a.webkit.gstFfmpeg}/lib/gstreamer-* 
    '';

  installFlags = "PREFIX=$out";

  meta = {
    description = "Tiny externally controllable webkit browser";
    maintainers = [a.lib.maintainers.raskin];
    platforms = with a.lib.platforms; 
      linux;
  };
}
