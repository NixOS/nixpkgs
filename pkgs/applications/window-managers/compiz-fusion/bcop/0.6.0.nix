args : with args;
	let localDefs = builderDefs {
		src = /* put a fetchurl here */
	fetchurl {
		url = http://releases.compiz-fusion.org/0.6.0/compiz-bcop-0.6.0.tar.bz2;
		sha256 = "0hw2ivvw696z325cqy7pmxb8cz30bqh67giw5fg6kzb9sn0x8v8f";
	};
		buildInputs = (import ../general-dependencies.nix args);
		propagatedBuildInputs = [getopt libxslt];
		configureFlags = [];
	} null; /* null is a terminator for sumArgs */
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
