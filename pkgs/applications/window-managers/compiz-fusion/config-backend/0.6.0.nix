args : with args;
	let localDefs = builderDefs {
		src = /* put a fetchurl here */
	fetchurl {
		url = http://releases.compiz-fusion.org/0.6.0/compizconfig-backend-gconf-0.6.0.tar.bz2;
		sha256 = "0h0r9sicc4pla5vag0j5qkllyagbs8dv5ai7fga48ln7q35y2mjr";
	};
		buildInputs = (import ../general-dependencies.nix args) ++
			[bcop libcompizconfig];
		configureFlags = [];
		forceShare = ["man" "doc" "info" "lib/compizconfig"];
	} null; /* null is a terminator for sumArgs */
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
