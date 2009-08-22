args : with args;
rec {
  src = fetchurl {
      url = "http://releases.compiz-fusion.org/core/compiz-0.8.0.tar.gz";
      sha256 = "0xhyilfz2cfbdwni774b54171addjqw7hda6j6snzxb1igny7iry";
    };

  buildInputs = [
    pkgconfig gtk libwnck GConf libgnome
    libgnomeui metacity gnomegtk glib pango libglade libgtkhtml
    gtkhtml libgnomecanvas libgnomeprint libgnomeprintui gnomepanel
    librsvg fuse gettext intltool binutils
  ];
  propagatedBuildInputs = [
    libpng libXcomposite libXfixes libXdamage libXrandr libXinerama
    libICE libSM startupnotification mesa GConf perl perlXMLParser libxslt
    dbus.libs dbus_glib compositeproto fixesproto damageproto randrproto
    xineramaproto renderproto kbproto xextproto libXrender xproto libX11
    libxcb
  ];

  postAll = fullDepEntry ("
    for i in $out/bin/*; do
     patchelf --set-rpath /var/run/opengl-driver/lib:$(patchelf --print-rpath $i) $i
    done
    ensureDir \$out/share/compiz-plugins/
    ln -sfv \$out/lib/compiz \$out/share/compiz-plugins/
  ") ["minInit" "doMakeInstall" "defEnsureDir"];

  configureFlags = ["--enable-gtk" "--enable-fuse"
          "--enable-annotate" "--enable-librsvg"] ++
          (if args ? extraConfigureFlags then args.extraConfigureFlags else []);

  /* doConfigure should be specified separately */
  phaseNames = [ "doPatch" "doConfigure" "doMakeInstall" "doPropagate"
			"doForceShare" "postAll" ];

  name = "compiz-0.8.0";

  meta = {
          description = "Compiz window manager";
          inherit src;
  };
}
