args : with args;
	let localDefs = builderDefs {
		src = /* put a fetchurl here */
	fetchurl {
		url = http://releases.compiz-fusion.org/0.6.0/compiz-fusion-plugins-main-0.6.0.tar.bz2;
		sha256 = "1pn6s8lrzgg2allfp1rdmd6kinx8whnj8sb38aqzirmy1s6gfsvi";
	};
		buildInputs = (import ../general-dependencies.nix args)++
		[bcop libjpeg gettext];
		configureFlags = [];
	} null; /* null is a terminator for sumArgs */
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
