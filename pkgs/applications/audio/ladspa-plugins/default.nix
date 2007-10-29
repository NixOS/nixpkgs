args: with args;
	with (builderDefs {
		src = 
		fetchurl {
			url = http://plugin.org.uk/releases/0.4.15/swh-plugins-0.4.15.tar.gz;
			sha256 = "0h462s4mmqg4iw7zdsihnrmz2vjg0fd49qxw2a284bnryjjfhpnh";
		};
		buildInputs = [fftw ladspaH pkgconfig];
		configureFlags = [];
	} null);
	with stringsWithDeps;
let
	postInstall = FullDepEntry ("
		ensureDir \$out/share/ladspa/
		ln -s \$out/lib/ladspa \$out/share/ladspa/lib
	") [minInit defEnsureDir];
in
stdenv.mkDerivation {
	name = "swh-plugins-0.4.15";
	builder = writeScript "swh-plugins-0.4.15-builder"
		(textClosure [doConfigure doMakeInstall postInstall doForceShare]);
	meta = {
		description = "
	LADSPA format audio plugins.
";
	};
}
