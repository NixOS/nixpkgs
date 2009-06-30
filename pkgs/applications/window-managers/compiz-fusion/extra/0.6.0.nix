args : with args;
	let localDefs = builderDefs {
		src = /* put a fetchurl here */
	fetchurl {
		url = http://releases.compiz-fusion.org/0.6.0/compiz-fusion-plugins-extra-0.6.0.tar.bz2;
		sha256 = "1k8477x1f27qbwvgp5pws81i50kbihk8mcqxbjjqv9i7scvaddvy";
	};
		buildInputs = (import ../general-dependencies.nix args)++
		[bcop libjpeg gettext pluginsMain];
		configureFlags = [];
	} null; /* null is a terminator for sumArgs */
	in with localDefs;
let
	sharePlugins = fullDepEntry ("
		ensureDir \$out/share/compiz-plugins
		ln -vsf \$out/lib/compiz \$out/share/compiz-plugins
	") [minInit doMakeInstall defEnsureDir];
	fixIncludes = fullDepEntry ("
sed -e 's@#include <text.h>@#include <compiz/text.h>@' -i src/group/group-internal.h;
sed -e 's@#include <text.h>@#include <compiz/text.h>@' -i src/scalefilter/scalefilter.c;
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
