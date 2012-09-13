a :  
let 
  fetchurl = a.fetchurl;

  version = a.lib.attrByPath ["version"] "0.15.1" a; 
  buildInputs = with a; [
    python pyGtkGlade gtk perl intltool dbus gettext
    pkgconfig makeWrapper libglade pyopenssl libXScrnSaver
    libXt xproto libXext xextproto libX11 gtkspell aspell
    scrnsaverproto pycrypto pythonDBus pythonSexy 
    docutils pyasn1
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
  '') ["addInputs" "doUnpack"];

  fixScriptNames = a.fullDepEntry (''
    mkdir "$out"/bin-wrapped
    for i in "$out"/bin/.*-wrapped; do
      name="$i"
      name="''${name%-wrapped}"
      name="''${name##*/.}"
      mv "$i" "$out/bin-wrapped/$name"
      sed -e 's^'"$i"'^'"$out/bin-wrapped/$name"'^' -i "$out/bin/$name"
    done
  '') ["wrapBinContentsPython"];

  deploySource = a.fullDepEntry (''
    mkdir -p "$out/share/gajim/src"
    cp -r *  "$out/share/gajim/src"
  '') ["minInit"];

  /* doConfigure should be removed if not needed */
  phaseNames = ["preConfigure" (a.doDump "1") "doConfigure" "doMakeInstall" 
    "wrapBinContentsPython" "fixScriptNames" "deploySource"];

  name = "gajim-" + version;
  meta = {
    description = "Jabber client with meta-contacts";
    maintainers = [a.lib.maintainers.raskin];
  };
}
