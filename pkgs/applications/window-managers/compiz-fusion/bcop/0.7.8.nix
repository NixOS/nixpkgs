args : with args;
	let localDefs = builderDefs.passthru.function {
		src = /* put a fetchurl here */
	fetchurl {
		url = http://releases.compiz-fusion.org/0.7.8/compiz-bcop-0.7.8.tar.bz2;
		sha256 ="1rs5r5b6rl39vlw68i8bwm5izs5dm666kygmg1c8dy2dab0xsnkq";
	};
		buildInputs = (import ../general-dependencies.nix args);
		propagatedBuildInputs = [getopt libxslt];
		configureFlags = [];
	} ;
	in with localDefs;
let 
	fixPkgconfig = fullDepEntry ("
		ensureDir \$out/lib
		ln -fs \$out/share/pkgconfig \$out/lib/pkgconfig
	") [minInit doMakeInstall defEnsureDir];
	fixInterpreter = fullDepEntry ("
		sed -e 's@^#!/bin/bash@#! ${stdenv.bash}/bin/bash@' -i \$out/bin/bcop
	") [minInit doMakeInstall];
in
stdenv.mkDerivation rec {
	name = "compiz-bcop-"+version;
	builder = writeScript (name + "-builder")
		(textClosure localDefs [doAutotools doConfigure doMakeInstall fixPkgconfig fixInterpreter doForceShare 
			doPropagate]);
	inherit propagatedBuildInputs;
	meta = {
		description = "
	Compiz BCOP.
";
		inherit src;
	};
}
