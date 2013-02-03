a :  
let 
  fetchurl = a.fetchurl;

  version = a.lib.attrByPath ["version"] "0.15.1" a; 
  buildInputs = with a; [
    python pyGtkGlade gtk perl intltool dbus gettext
    pkgconfig makeWrapper libglade pyopenssl libXScrnSaver
    libXt xproto libXext xextproto libX11 gtkspell aspell
    scrnsaverproto pycrypto pythonDBus pythonSexy 
    docutils pyasn1 farstream gst_plugins_bad gstreamer
    gst_ffmpeg gst_python
  ];
in
rec {
  src = fetchurl {
    url = "http://www.gajim.org/downloads/0.15/gajim-${version}.tar.gz";
    sha256 = "b315d4a600da0c5f8248e8f887a41ce2630c49995b36cbad8fb2cd81cc8d2e8b";
  };

  inherit buildInputs;
  configureFlags = [];

  preConfigure = a.fullDepEntry (''
    export PYTHONPATH="$PYTHONPATH''${PYTHONPATH:+:}$(toPythonPath ${a.pyGtkGlade})/gtk-2.0"
    export PYTHONPATH="$PYTHONPATH''${PYTHONPATH:+:}$(toPythonPath ${a.pygobject})/gtk-2.0"
    sed -e '/-L[$]x_libraries/d' -i configure
    sed -e 's@tmpfd.close()@os.close(tmpfd)@' -i src/common/latex.py
  '') ["addInputs" "doUnpack"];

  fixScriptNames = a.fullDepEntry (''
    mkdir "$out"/bin-wrapped
    for i in "$out"/bin/.*-wrapped; do
      name="$i"
      name="''${name%-wrapped}"
      name="''${name##*/.}"
      mv "$i" "$out/bin-wrapped/$name"
      sed -e 's^'"$i"'^'"$out/bin-wrapped/$name"'^' -i "$out/bin/$name"
      sed -e "2aexport LD_LIBRARY_PATH=\"\$LD_LIBRARY_PATH\''${LD_LIBRARY_PATH:+:}${a.gtkspell}/lib:${a.gtkspell}/lib64\"" -i "$out/bin/gajim"
      sed -e "2aexport NIX_LDFLAGS=\"\$NIX_LDFLAGS -L${a.gtkspell}/lib -L${a.gtkspell}/lib64\"" -i "$out/bin/gajim"
      sed -e "2aexport GST_PLUGIN_PATH=\"\$GST_PLUGIN_PATH''${GST_PLUGIN_PATH:+:}$(echo ${a.gst_plugins_bad}/lib/gstreamer-*):$(echo ${a.gst_ffmpeg}/lib/gstreamer-*):$(echo ${a.farstream}/lib/gstreamer-*)\"" -i "$out/bin/gajim"
    done
  '') ["wrapBinContentsPython"];

  /* doConfigure should be removed if not needed */
  phaseNames = ["preConfigure" (a.doDump "1") "doConfigure" "doMakeInstall" 
    "wrapBinContentsPython" "fixScriptNames"];

  name = "gajim-" + version;
  meta = {
    description = "Jabber client with meta-contacts";
    maintainers = [a.lib.maintainers.raskin];
  };
}
