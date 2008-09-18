args : with args;
	let localDefs = builderDefs.meta.function {
		src = /* put a fetchurl here */
	fetchurl {
		url = http://xorg.freedesktop.org/archive/individual/app/compiz-0.7.8.tar.gz;
		sha256 = "00v5br8vi9ycrzvgdsmdbv31kv1n9g88hxm0ax9yhy6cfsvm4vxl";
	};
		buildInputs = [
			    pkgconfig gtk libwnck GConf libgnome 
			    libgnomeui metacity gnomegtk glib pango libglade libgtkhtml 
			    gtkhtml libgnomecanvas libgnomeprint libgnomeprintui gnomepanel 
			    librsvg fuse gettext
		];
		  propagatedBuildInputs = [
		    libpng libXcomposite libXfixes libXdamage libXrandr libXinerama
		    libICE libSM startupnotification mesa GConf perl perlXMLParser libxslt
		    dbus.libs dbus_glib compositeproto fixesproto damageproto randrproto
		    xineramaproto renderproto kbproto xextproto libXrender xproto libX11
		    libxcb
		  ];
		configureFlags = ["--enable-gtk" "--enable-fuse" 
			"--enable-annotate" "--enable-librsvg"] ++ 
			(if args ? extraConfigureFlags then args.extraConfigureFlags else []);
		patches = [ ./glx-patch-0.6.2.patch ];
	};
	in with localDefs;
let
	postAll = FullDepEntry ("
    for i in $out/bin/*; do
     patchelf --set-rpath /var/run/opengl-driver/lib:$(patchelf --print-rpath $i) $i
    done
    ensureDir \$out/share/compiz-plugins/
    ln -sfv \$out/lib/compiz \$out/share/compiz-plugins/
  ") [minInit doMakeInstall defEnsureDir];
in

stdenv.mkDerivation 
rec {
	name = "compiz-0.7.8";
	builder = writeScript (name + "-builder")
		(textClosure localDefs [doPatch doConfigure doMakeInstall doPropagate 
			doForceShare postAll]);
	inherit propagatedBuildInputs;
	meta = {
		description = "
	Compiz window manager
";
		inherit src;
	};
}

