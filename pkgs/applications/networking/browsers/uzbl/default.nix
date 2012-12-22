a :  
let 
  fetchgit = a.fetchgit;

  buildInputs = with a; [
    libsoup pkgconfig webkit gtk makeWrapper
    kbproto glib pango cairo gdk_pixbuf atk
    python3
  ];
in
rec {
  src = fetchgit {
    url = "https://github.com/Dieterbe/uzbl.git";
    rev = "refs/tags/2012.05.14";
    sha256 = "1crvikb0qqsx5qb003i4w7ywh72psl37gjslrj5hx2fd2f215l0l";
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

  installFlags = "PREFIX=$out PYINSTALL_EXTRA=\"--prefix=$out\"";
      
  meta = {
    description = "Tiny externally controllable webkit browser";
    maintainers = [a.lib.maintainers.raskin];
  };
}
