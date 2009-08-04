a :  
let 
  fetchurl = a.fetchurl;

  version = a.lib.attrByPath ["version"] "0.12.1" a; 
  buildInputs = with a; [
    python pyGtkGlade gtk perl intltool dbus gettext
    pkgconfig makeWrapper libglade pyopenssl libXScrnSaver
    libXt xproto libXext xextproto libX11 gtkspell aspell
    scrnsaverproto pycrypto pythonDBus pythonSexy 
    docutils
  ];
in
rec {
  src = fetchurl {
    url = "http://www.gajim.org/downloads/gajim-${version}.tar.gz";
    sha256 = "1iglh0i819m1a8qjkbyv2ydzbzhjgnaxyyq1jnikrwlbah5mjpbv";
  };

  inherit buildInputs;
  configureFlags = [];

  preConfigure = a.fullDepEntry (''
    export PYTHONPATH="$PYTHONPATH''${PYTHONPATH:+:}$(toPythonPath ${a.pyGtkGlade})/gtk-2.0"
    export PYTHONPATH="$PYTHONPATH''${PYTHONPATH:+:}$(toPythonPath ${a.pygobject})/gtk-2.0"
    sed -e '/-L[$]x_libraries/d' -i configure
  '') ["addInputs" "doUnpack"];

  /* doConfigure should be removed if not needed */
  phaseNames = ["preConfigure" (a.doDump "1") "doConfigure" "doMakeInstall" "wrapBinContentsPython"];

  name = "gajim-" + version;
  meta = {
    description = "Jabber client with meta-contacts";
    maintainers = [a.lib.maintainers.raskin];
  };
}
