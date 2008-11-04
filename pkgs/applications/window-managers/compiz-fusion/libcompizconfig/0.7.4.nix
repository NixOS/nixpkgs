args : with args;
	let localDefs = builderDefs.passthru.function {
		src = /* put a fetchurl here */
	fetchurl {
		url = http://releases.compiz-fusion.org/0.7.4/libcompizconfig-0.7.4.tar.bz2;
		sha256 = "0y5hfah30giszilg8v0v10vg45rnc9gdjbsqawdjn2q6bh3xzmr3";
	};
		buildInputs = (import ../general-dependencies.nix args)++
			[bcop];
		configureFlags = [];
	} ;
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
