args : with args;
	let localDefs = builderDefs {
		src = /* put a fetchurl here */
	fetchurl {
		url = http://releases.compiz-fusion.org/0.7.4/ccsm-0.7.4.tar.bz2;
		sha256 = "0267xvz2j476r1awiwkfhfahjh8p1al6ip0qjzlw1lidmd9fdbxv";
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
	} null; /* null is a terminator for sumArgs */
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
