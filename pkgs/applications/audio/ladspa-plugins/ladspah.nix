args: with args;
let 
	src = 
	fetchurl {
		url = http://www.ladspa.org/ladspa_sdk/ladspa.h.txt;
		sha256 = "1b908csn85ng9sz5s5d1mqk711cmawain2z8px2ajngihdrynb67";
	};
in
	with builderDefs {
		buildInputs = [];
		inherit src;
	} null;
let
	copyFile = FullDepEntry ("
		ensureDir \$out/include
		cp ${src} \$out/include/ladspa.h
	") [minInit defEnsureDir];
in
stdenv.mkDerivation {
	name = "ladspa.h";
	builder = writeScript "ladspa.h-builder"
		(textClosure [copyFile]);
	meta = {
		description = "
	LADSPA format audio plugins.
";
	};
}
