args : with args; with builderDefs;
	let localDefs = builderDefs.passthru.function ((rec {
		src = /* put a fetchurl here */
		fetchurl {
			url = http://launchpad.net/linuxdcpp/1.0/1.0.3/+download/linuxdcpp-1.0.3.tar.bz2;
			sha256 = "0w9c8k13cl85y4v4av8ic6w4zkdivcj6p5q86llfh3sz077vckiv";
		};

		buildInputs = [scons pkgconfig gtk bzip2 pkgconfig libglade
			openssl libX11];
		configureFlags = [];
		doScons = fullDepEntry (''
			ensureDir $out
			export NIX_LDFLAGS="$NIX_LDFLAGS -lX11";
			scons PREFIX=$out 
			scons PREFIX=$out install
		'') ["minInit" "doUnpack" "addInputs" "defEnsureDir"];
	}) //  args);
	in with localDefs;
stdenv.mkDerivation rec {
	name = "ldcpp-1.0.3";
	builder = writeScript (name + "-builder")
		(textClosure localDefs 
			[doScons doForceShare doPropagate]);
	meta = {
		description = "Linux DC++ - Direct Connect client";
		inherit src;
	};
}
