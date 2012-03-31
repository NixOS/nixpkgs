a :  
let 
  fetchgit = a.fetchgit;

  buildInputs = with a; [
    libsoup pkgconfig webkit gtk3 makeWrapper
    kbproto
  ];
in
rec {
  src = fetchgit {
    url = "https://github.com/Dieterbe/uzbl.git";
    rev = "dcb3b4e1fcff682b412cfe5875f7054b97380d08";
    sha256 = "f7b2b2903c01c9cfbd99bd94783002e1580d8092ff6022bb5aed3f999ff6e468";
  };

  name = "uzbl-git";

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
      --prefix GST_PLUGIN_PATH : ${a.webkit.gst_plugins_base}/lib/gstreamer-* \
      --prefix GST_PLUGIN_PATH : ${a.webkit.gst_plugins_good}/lib/gstreamer-* \
      --prefix GST_PLUGIN_PATH : ${a.webkit.gst_ffmpeg}/lib/gstreamer-* \
      --prefix GIO_EXTRA_MODULES : ${a.glib_networking}/lib/gio/modules
    '';

  installFlags = "PREFIX=$out";
      
  meta = {
    description = "Tiny externally controllable webkit browser";
    maintainers = [a.lib.maintainers.raskin];
  };
}
