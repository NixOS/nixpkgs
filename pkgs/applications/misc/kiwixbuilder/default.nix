args : with args; with builderDefs {src="";} null;
	let localDefs = builderDefs (rec {
		src = /* put a fetchurl here */
		fetchurl {
			url = http://downloads.sourceforge.net/kiwix/kiwixbuilder.tgz;
			sha256 = "0qb97smw4675i3hh328a7f65payw1w71bn4d32ycdkmqk56zl4ds";
		};
		buildInputs = [glib zlib];
		configureFlags = [" --prefix=$out "];
		preConfigure = fullDepEntry (''
			export NIX_CFLAGS_COMPILE=$NIX_CFLAGS_COMPILE' -I${glib}/include/glib-2.0/ -I${glib}/lib/glib-2.0/include/ '
			export NIX_LDFLAGS=$NIX_LDFLAGS' -lglib-2.0 '
			sed -e 's@/usr/local/lib/libz\.a@${zlib}/lib/libz.a@' -i configure
		'') ["minInit" "doUnpack"];
	}) args null; /* null is a terminator for sumArgs */
	in with localDefs;
stdenv.mkDerivation rec {
	name = "kiwix";
	builder = writeScript (name + "-builder")
		(textClosure localDefs 
			[preConfigure doConfigure doMakeInstall doForceShare doPropagate]);
	meta = {
		description = "
		Offline Wikipedia viewer builder.
";
		inherit src;
	};
}
