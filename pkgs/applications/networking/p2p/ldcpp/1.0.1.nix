args : with args; with builderDefs;
	let localDefs = builderDefs.passthru.function ((rec {
		src = /* put a fetchurl here */
		fetchurl {
			url = http://download2.berlios.de/linuxdcpp/linuxdcpp-1.0.1.tar.bz2;
			sha256 = "0f0vvsa3x3nirqnf2lagpmbbj3pgdcp6wa2gvadj294b3va4hx34";
		};

		buildInputs = [scons pkgconfig gtk bzip2 pkgconfig libglade
			openssl libX11];
		configureFlags = [];
		doScons = FullDepEntry (''
			ensureDir $out
			export NIX_LDFLAGS="$NIX_LDFLAGS -lX11";
			scons PREFIX=$out 
			scons PREFIX=$out install
		'') ["minInit" "doUnpack" "addInputs" "defEnsureDir"];
	}) //  args);
	in with localDefs;
stdenv.mkDerivation rec {
	name = "ldcpp-"+version;
	builder = writeScript (name + "-builder")
		(textClosure localDefs 
			[doScons doForceShare doPropagate]);
	meta = {
		description = "
		Linux DC++ - Direct Connect client
";
		inherit src;
	};
}
