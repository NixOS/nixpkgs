args : with args;
	let localDefs = builderDefs.passthru.function {
		src = /* put a fetchurl here */
	fetchurl {
		url = http://releases.compiz-fusion.org/0.7.4/compiz-fusion-plugins-main-0.7.4.tar.bz2;
		sha256 = "1dk8gb0ysij9ny51x9xgz595zbh6cm37hfbn1y738s471cjh7mp3";
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
