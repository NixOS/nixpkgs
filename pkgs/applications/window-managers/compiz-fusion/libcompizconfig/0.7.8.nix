args : with args;
	let localDefs = builderDefs.meta.function {
		src = /* put a fetchurl here */
	fetchurl {
		url = http://releases.compiz-fusion.org/0.7.8/libcompizconfig-0.7.8.tar.bz2;
		sha256 ="1026icgzyjxnn68gbkd85n9p8pxlwbc3h0dqqvpqmr93q1nhdmjr";
	};
		buildInputs = (import ../general-dependencies.nix args)++
			[bcop];
		configureFlags = [];
	} ;
	in with localDefs;
stdenv.mkDerivation rec {
	name = "libcompizconfig-"+version;
	builder = writeScript (name + "-builder")
		(textClosure localDefs [doIntltool doAutotools doConfigure doMakeInstall doForceShare]);
	meta = {
		description = "
	Compiz configuration backend library.
";
		inherit src;
	};
}
