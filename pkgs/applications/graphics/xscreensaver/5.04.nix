args : with args; let localDefs = builderDefs (args // {
		src = /* put a fetchurl here */
		fetchurl {
			url = http://www.jwz.org/xscreensaver/xscreensaver-5.04.tar.gz;
			sha256 = "1mx6zc6rvb6pr9wb6mv4ljiii9ybw0dshd74aclf7rlmfx4hn86i";
		};
		useConfig = true;
		reqsList = [
			["true" "libX11" "gtk" "pkgconfig" "bc" "perl" "intltool" "libXmu"]
			["GL" "mesa"]
			["GUI" "gtk" "libxml2" "libglade"]
			["jpeg" "libjpeg"]
			["false"]
		];
		configFlags = [
			"GL" " --with-gl "
			"gdkpixbuf" " --with-pixbuf "
			"DPMS" " --with-dpms "
			"true" (" --with-x-app-defaults=\$out/share/xscreensaver/app-defaults "+
				" --with-hackdir=\$out/share/xscreensaver-hacks ")
		];
	}) null; /* null is a terminator for sumArgs */
	in with localDefs;
let 
	preConfigure = FullDepEntry ("
		sed -e 's%@GTK_DATADIR@%@datadir@% ; s%@PO_DATADIR@%@datadir@%' "+
		"-i driver/Makefile.in po/Makefile.in.in;
	") [minInit doUnpack];
in
stdenv.mkDerivation rec {
	name = "xscreensaver-"+version;
	builder = writeScript (name + "-builder")
		(textClosure localDefs [preConfigure doConfigure doMakeInstall doForceShare doPropagate]);
	meta = {
		description = "
	The X screensaver daemon. Run xscreensaver-demo to configure.
";
		inherit src;
	};
}
