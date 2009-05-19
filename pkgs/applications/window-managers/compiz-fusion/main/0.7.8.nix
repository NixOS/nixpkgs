args : with args;
	let localDefs = builderDefs.passthru.function {
		src = /* put a fetchurl here */
	fetchurl {
		url = http://releases.compiz-fusion.org/0.7.8/compiz-fusion-plugins-main-0.7.8.tar.bz2;
		sha256 ="0lrvqi8kc8m6yap8pqbdg0wksckd3v3rp3k48q82pyvcwhaaf817";
	};
		buildInputs = (import ../general-dependencies.nix args)++
		[bcop libjpeg gettext];
		configureFlags = [];
	} ;
	in with localDefs;
let
	sharePlugins = fullDepEntry ("
		ensureDir \$out/share/compiz-plugins
		ln -vsf \$out/lib/compiz \$out/share/compiz-plugins
	") [minInit doMakeInstall defEnsureDir];
in
stdenv.mkDerivation rec {
	name = "compiz-fusion-plugins-main-"+version;
	builder = writeScript (name + "-builder")
		(textClosure localDefs [doConfigure doMakeInstall sharePlugins doForceShare]);
	meta = {
		description = "
	Main Compiz Fusion plugins.
";
		inherit src;
	};
}
