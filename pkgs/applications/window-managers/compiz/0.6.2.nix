args : with args;
	with builderDefs {
		src = /* put a fetchurl here */
	fetchurl {
		url = http://releases.compiz-fusion.org/compiz/0.6.2/compiz-0.6.2.tar.bz2;
		sha256 = "0k58bkbyqx94ch7scvn3d26296ai9nddfb6lg8v3bhbi2zj4i2n5";
	};
		buildInputs = [
			    pkgconfig libXrender xextproto gtk libwnck GConf libgnome 
			    libgnomeui metacity gnomegtk glib pango libglade libgtkhtml 
			    gtkhtml libgnomecanvas libgnomeprint libgnomeprintui gnomepanel 
			    librsvg fuse
		];
		  propagatedBuildInputs = [
		    libpng libXcomposite libXfixes libXdamage libXrandr libXinerama
		    libICE libSM startupnotification mesa GConf perl perlXMLParser libxslt
		  ];
		configureFlags = ["--enable-gtk" "--enable-fuse" 
			"--enable-annotate" "--enable-librsvg"];
	} null; /* null is a terminator for sumArgs */
	with stringsWithDeps;
let
	postAll = FullDepEntry ("
    for i in $out/bin/*; do
     patchelf --set-rpath /var/run/opengl-driver/lib:$(patchelf --print-rpath $i) $i
    done
  ") [minInit doMakeInstall];
in

stdenv.mkDerivation 
rec {
	name = "compiz-0.6.2";
	builder = writeScript (name + "-builder")
		(textClosure [doConfigure doMakeInstall doForceShare postAll]);
	meta = {
		description = "
	Compiz window manager
";
	};
}
