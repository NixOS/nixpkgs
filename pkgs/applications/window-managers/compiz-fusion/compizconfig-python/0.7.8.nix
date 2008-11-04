args : with args;
	let localDefs = builderDefs.passthru.function {
		src = /* put a fetchurl here */
	fetchurl {
		url = http://releases.compiz-fusion.org/0.7.8/compizconfig-python-0.7.8.tar.bz2;
		sha256 ="13g8vpgkimrbp19pd475ijiwbqx3zin0nzq8636l71yaqb0kjfjn";
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
