args : with args;
	let localDefs = builderDefs.meta.function {
		src = /* put a fetchurl here */
	fetchurl {
		url = http://releases.compiz-fusion.org/0.7.4/compiz-fusion-plugins-extra-0.7.4.tar.bz2;
		sha256 = "0zncmzccnw8avvj20h1xfh8s5f1xgwwry0fkhw444phx7pwcds3w";
	};
		buildInputs = (import ../general-dependencies.nix args)++
		[bcop libjpeg gettext pluginsMain];
		configureFlags = [];
	} ;
	in with localDefs;
let
	sharePlugins = FullDepEntry ("
		ensureDir \$out/share/compiz-plugins
		ln -vsf \$out/lib/compiz \$out/share/compiz-plugins
	") [minInit doMakeInstall defEnsureDir];
	fixIncludes = FullDepEntry ("
sed -e 's@#include <compiz-text.h>@#include <compiz/compiz-text.h>@' -i src/group/group-internal.h;
sed -e 's@#include <compiz-text.h>@#include <compiz/compiz-text.h>@' -i src/scalefilter/scalefilter.c;
sed -e 's@#include <compiz-mousepoll.h>@#include <compiz/compiz-mousepoll.h>@' -i src/showmouse/showmouse.c;
	") [minInit doUnpack];
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
