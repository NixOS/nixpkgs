args : with args;
	let localDefs = builderDefs.meta.function {
		src = /* put a fetchurl here */
	fetchurl {
		url = http://releases.compiz-fusion.org/0.7.8/ccsm-0.7.8.tar.bz2;
		sha256 ="0s8difywj0ghc8c5xjxihfp8qhlhv5kyh00c2br1jh2ap5rrdfgc";
	};
		buildInputs = (import ../general-dependencies.nix args) ++
			[libcompizconfig bcop compizConfigPython python gettext pygtk 
			pycairo configBackendGConf];
		configureFlags = [];
		wrappedEnv = [
			"PYTHONPATH" "$(toPythonPath \$out)"
			"PYTHONPATH" "\$PYTHONPATH"
			"PYTHONPATH" "$(toPythonPath ${pygtk})/gtk-2.0"
		];
	} ;
	in with localDefs;
stdenv.mkDerivation rec {
	name = "compizconfig-settings-"+args.version;
	builder = writeScript (name + "-builder")
		(textClosure localDefs [installPythonPackage (doWrap "\$out/bin/ccsm")]);
	meta = {
		description = "
	Compiz Settings Manager
";
		inherit src;
	};
}
