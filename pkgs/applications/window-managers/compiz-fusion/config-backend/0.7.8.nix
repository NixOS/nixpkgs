args : with args;
	let localDefs = builderDefs.passthru.function {
		src = /* put a fetchurl here */
	fetchurl {
		url = http://releases.compiz-fusion.org/0.7.8/compizconfig-backend-gconf-0.7.8.tar.bz2;
		sha256 ="18bcfx3c2ipj3spfr8dg07h98pw77jh28w91w6n2fd5ffr6ja9q5";
	};
		buildInputs = (import ../general-dependencies.nix args) ++
			[bcop libcompizconfig];
		configureFlags = [];
		forceShare = ["man" "doc" "info" "lib/compizconfig"];
	} ;
	in with localDefs;
stdenv.mkDerivation rec {
	name = "compizconfig-backend-GConf-"+version;
	builder = writeScript (name + "-builder")
		(textClosure localDefs [doAutotools doConfigure doMakeInstall doForceShare doPropagate]);
	meta = {
		description = "
	Compiz configuration backend (GConf).
";
		inherit src;
	};
}
