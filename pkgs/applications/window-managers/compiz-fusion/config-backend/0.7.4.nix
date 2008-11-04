args : with args;
	let localDefs = builderDefs.passthru.function {
		src = /* put a fetchurl here */
	fetchurl {
		url = http://releases.compiz-fusion.org/0.7.4/compizconfig-backend-gconf-0.7.4.tar.bz2;
		sha256 = "0gvb81zlp0wciq0cp7g1wnldm5p1n21i6zfwjm26ialphi4m47ly";
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
