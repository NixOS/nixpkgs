args : with args;
	let localDefs = builderDefs.passthru.function {
		src = /* put a fetchurl here */
fetchurl {
		url = http://prdownloads.sourceforge.net/jocr/gocr-0.44.tar.gz;
		sha256 = "0kvb7cbk6z5n4g0hhbwpdk2f3819yfamwsmkwanj99yhni6p5mr0";
	};

		buildInputs = [];
		configureFlags = [];
	};
	in with localDefs;
stdenv.mkDerivation rec {
	name = "gocr";
	builder = writeScript (name + "-builder")
		(textClosure localDefs [doConfigure doMakeInstall doForceShare doPropagate]);
	meta = {
		description = "GPL Optical Character Recognition";
		inherit src;
	};
}
