args : with args;
	with builderDefs {
		src = /* put a fetchurl here */
	fetchurl {
		url = http://releases.compiz-fusion.org/0.6.0.1/compizconfig-python-0.6.0.1.tar.bz2;
		sha256 = "0im67mxnm30a3xd3rvfwrgfp4ic2x5axpjdahx0f5p9pnfy0jm4n";
	};
		buildInputs = (import ../general-dependencies.nix args) ++
			[libcompizconfig bcop python pyrex];
		configureFlags = [];
	} null; /* null is a terminator for sumArgs */
	with stringsWithDeps;
stdenv.mkDerivation rec {
	name = "compizconfig-python-"+args.version;
	builder = writeScript (name + "-builder")
		(textClosure [doAutotools doConfigure doMakeInstall doForceShare]);
	meta = {
		description = "
	Compiz configuration - Python part.
";
	};
}
