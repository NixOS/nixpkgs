a :  
let 
  fetchurl = a.fetchurl;

  s = import ./src-for-default.nix;

  buildInputs = with a; [
    libsoup pkgconfig webkit gtk makeWrapper
    kbproto
  ];
in
rec {
  src = (a.fetchUrlFromSrcInfo s);
  inherit (s) name;

  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be removed if not needed */
  phaseNames = ["addInputs" "setVars" "doMakeInstall" "doWrap"];

  setVars = a.noDepEntry (''
    export NIX_LDFLAGS="$NIX_LDFLAGS -L${a.libX11}/lib -lX11"
  '');

  doWrap = a.makeManyWrappers "$out/bin/uzbl-core" 
    ''
      --prefix GST_PLUGIN_PATH : ${a.webkit.gstreamer}/lib/gstreamer-* \
      --prefix GST_PLUGIN_PATH : ${a.webkit.gstPluginsBase}/lib/gstreamer-* \
      --prefix GST_PLUGIN_PATH : ${a.webkit.gstPluginsGood}/lib/gstreamer-* \
      --prefix GST_PLUGIN_PATH : ${a.webkit.gstFfmpeg}/lib/gstreamer-* \
      --prefix GIO_EXTRA_MODULES : ${a.glib_networking}/lib/gio/modules
    '';

  installFlags = "PREFIX=$out";
      
  meta = {
    description = "Tiny externally controllable webkit browser";
    maintainers = [a.lib.maintainers.raskin];
  };
}
