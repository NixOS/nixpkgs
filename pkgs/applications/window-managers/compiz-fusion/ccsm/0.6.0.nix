args : with args;
	with builderDefs {
		src = /* put a fetchurl here */
	fetchurl {
		url = http://releases.compiz-fusion.org/0.6.0/ccsm-0.6.0.tar.bz2;
		sha256 = "11vv7ljy79szf74bp7wq969aj05p0x785zbiap1jnqlwq1wjkhir";
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
	with stringsWithDeps;
stdenv.mkDerivation rec {
	name = "compizconfig-settings-"+args.version;
	builder = writeScript (name + "-builder")
		(textClosure [installPythonPackage (doWrap "\$out/bin/ccsm")]);
	meta = {
		description = "
	Compiz Settings Manager
";
	};
}
