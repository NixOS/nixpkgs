args : with args;
	let localDefs = builderDefs {
		src = /* put a fetchurl here */
	fetchurl {
		url = http://releases.compiz-fusion.org/0.6.0/libcompizconfig-0.6.0.tar.bz2;
		sha256 = "1p75p29qg2syk1b4cvkf9ds5qv3h2jnqa6gs38rivbyqqvrcgkij";
	};
		buildInputs = (import ../general-dependencies.nix args)++
			[bcop];
		configureFlags = [];
	} null; /* null is a terminator for sumArgs */
	in with localDefs;
stdenv.mkDerivation rec {
	name = "libcompizconfig-"+version;
	builder = writeScript (name + "-builder")
		(textClosure localDefs [doAutotools doConfigure doMakeInstall doForceShare]);
	meta = {
		description = "
	Compiz configuration backend library.
";
		inherit src;
	};
}
