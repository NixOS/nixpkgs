args : with args; let localDefs = builderDefs.passthru.function (args // rec {
                version = lib.attrByPath ["version"] "5.10" args;
		src = /* put a fetchurl here */
		fetchurl {
		    url = "http://www.jwz.org/xscreensaver/xscreensaver-${version}.tar.gz";
		    sha256 = "07zy157wqwgcapqycyv89yabxa8byk4p8jn3zlvhf7lx5w1xmval";
		};
		useConfig = true;
		reqsList = [
			["true" "libX11" "pkgconfig" "bc" "perl" "intltool" "libXmu"]
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
	});
	in with localDefs;
let
	preConfigure = fullDepEntry ("
		sed -e 's%@GTK_DATADIR@%@datadir@% ; s%@PO_DATADIR@%@datadir@%' "+
		"-i driver/Makefile.in po/Makefile.in.in;
	") ["minInit" "doUnpack"];
in
stdenv.mkDerivation rec {
	name = "xscreensaver-5.10";
	buildCommand = textClosure localDefs
          [preConfigure doConfigure doMakeInstall doForceShare doPropagate];
	meta = {
		description = "A set of screensavers";
		inherit src;
    		maintainers = [stdenv.lib.maintainers.raskin];
		platforms = stdenv.lib.platforms.allBut "i686-cygwin";
	};
}
