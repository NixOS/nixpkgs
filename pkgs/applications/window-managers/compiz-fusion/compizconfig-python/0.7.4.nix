args : with args;
	let localDefs = builderDefs.passthru.function {
		src = /* put a fetchurl here */
	fetchurl {
		url = http://releases.compiz-fusion.org/0.7.4/compizconfig-python-0.7.4.tar.bz2;
		sha256 = "0y9r1cp0f5c3x7ysbdkil6156nhy4a7aqhmxqdg3hjwwgkfsgi9d";
	};
		buildInputs = (import ../general-dependencies.nix args) ++
			[libcompizconfig bcop python pyrex configBackendGConf];
		configureFlags = [];
	} ;
	in with localDefs;
stdenv.mkDerivation rec {
	name = "compizconfig-python-"+args.version;
	builder = writeScript (name + "-builder")
		(textClosure localDefs [doAutotools doConfigure doMakeInstall doForceShare]);
	meta = {
		description = "
	Compiz configuration - Python part.
";
		inherit src;
	};
}
