args : with args;
	let localDefs = builderDefs.passthru.function {
		src = /* put a fetchurl here */
	fetchurl {
		url = http://releases.compiz-fusion.org/0.7.8/compiz-fusion-plugins-extra-0.7.8.tar.bz2;
		sha256 ="0hdnabq1bxln5cf6k9532iszj5qbhwkyl3b5d1gwfr80i01qxzy9";
	};
		buildInputs = (import ../general-dependencies.nix args)++
		[bcop libjpeg gettext pluginsMain];
		configureFlags = [];
	} ;
	in with localDefs;
let
	sharePlugins = fullDepEntry ("
		ensureDir \$out/share/compiz-plugins
		ln -vsf \$out/lib/compiz \$out/share/compiz-plugins
	") [minInit doMakeInstall defEnsureDir];
	fixIncludes = fullDepEntry (''
		export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${pluginsMain}/include/compiz"
	'') [minInit doUnpack];
in
stdenv.mkDerivation rec {
	name = "compiz-fusion-plugins-extra-"+version;
	builder = writeScript (name + "-builder")
		(textClosure localDefs [fixIncludes doConfigure doMakeInstall sharePlugins doForceShare]);
	meta = {
		description = "
	Extra Compiz Fusion plugins.
";
		inherit src;
	};
}
