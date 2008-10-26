args : with args;
	let localDefs = builderDefs.meta.function {
		src = /* put a fetchurl here */
	fetchurl {
		url = http://releases.compiz-fusion.org/0.7.8/simple-ccsm-0.7.8.tar.bz2;
		sha256 ="0djdzz1m9nvwzxfaywdm90bi816nig2ybfynf48394a5hpsng3l9";
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
		(textClosure localDefs [installPythonPackage (doWrap "\$out/bin/simple-ccsm")]);
	meta = {
		description = "
	Compiz Settings Manager (simplified)
";
		inherit src;
	};
}
