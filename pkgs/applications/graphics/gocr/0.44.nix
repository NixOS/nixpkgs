args : with args;
	with builderDefs {
		src = /* put a fetchurl here */
fetchurl {
		url = http://prdownloads.sourceforge.net/jocr/gocr-0.44.tar.gz;
		sha256 = "0kvb7cbk6z5n4g0hhbwpdk2f3819yfamwsmkwanj99yhni6p5mr0";
	};

		buildInputs = [];
		configureFlags = [];
	} null; /* null is a terminator for sumArgs */
stdenv.mkDerivation rec {
	name = "gocr";
	builder = writeScript (name + "-builder")
		(textClosure [doConfigure doMakeInstall doForceShare doPropagate]);
	meta = {
		description = "
		GPL Optical Character Recognition
";
	};
}
