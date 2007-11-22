args : with args;
	with builderDefs {
		src = /* put a fetchurl here */
	fetchurl {
		url = http://garr.dl.sourceforge.net/sourceforge/fbpanel/fbpanel-4.12.tgz;
		sha256 = "0zv0zkq6w4h7dk0ji8bm9cqpj2qxv3ss161mqg9y68shvxvmfrlz";
	};

		buildInputs = [libX11 gtk pkgconfig libXmu libXpm 
		  libpng libjpeg libtiff librsvg];
		configureFlags = [];
	} null; /* null is a terminator for sumArgs */
stdenv.mkDerivation rec {
	name = "fbpanel";
	builder = writeScript (name + "-builder")
		(textClosure [doConfigure doMakeInstall doForceShare doPropagate]);
	meta = {
		description = "
	Just a desktop panel.	
";
	};
}
