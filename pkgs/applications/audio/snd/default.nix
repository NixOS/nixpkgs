args : with args;
	with builderDefs {
		src = 
	fetchurl {
		url = ftp://ccrma-ftp.stanford.edu/pub/Lisp/snd-9.4.tar.gz;
		sha256 = "0zqgfnkvkqxby1k74mwba1r4pb520glcsz5jjmpzm9m41nqnghmm";
	};

		buildInputs = [gtk glib pkgconfig libXpm gmp gettext]
			++ (lib.optional (args ? ruby) args.ruby)
			++ (lib.optional (args ? mesa) args.mesa)
			++ (lib.optional (args ? guile) args.guile)
			++ (lib.optional (args ? libtool) args.libtool)
			++ (lib.optional (args ? sndlib) args.sndlib)
			;
		configureFlags = ["--with-gtk" "--with-xpm"]
			++ (lib.optional (args ? ruby)   "--with-ruby" )
			++ (lib.optional (args ? mesa)   "--with-gl"   )
			++ (lib.optional (args ? guile)  "--with-guile")
			++ (lib.optional (args ? sndlib) "--with-midi" )
			;
	} null; /* null is a terminator for sumArgs */
	let preBuild = FullDepEntry ("
		cp config.log /tmp/snd-config.log
	") [minInit doUnpack];
in
stdenv.mkDerivation rec {
	name = "Snd-9.4";
	builder = writeScript (name + "-builder")
		(textClosure [doConfigure preBuild doMakeInstall doForceShare]);
	meta = {
		description = "
		Snd sound editor.
";
	};
}
