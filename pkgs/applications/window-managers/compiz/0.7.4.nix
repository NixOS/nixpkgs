args : with args;
	let localDefs = builderDefs.meta.function {
		src = /* put a fetchurl here */
	fetchurl {
		url = http://releases.compiz-fusion.org/0.7.4/compiz/compiz-0.7.4.tar.bz2;
		sha256 = "1ik2wlrc469l0l9j7yhfapcmwkshhva5b5sh5h4czg3bj5iivaf7";
	};
		buildInputs = [
			    pkgconfig gtk libwnck GConf libgnome 
			    libgnomeui metacity gnomegtk glib pango libglade libgtkhtml 
			    gtkhtml libgnomecanvas libgnomeprint libgnomeprintui gnomepanel 
			    librsvg fuse 
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
	name = "compiz-"+version;
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

