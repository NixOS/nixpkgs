args: with args;
	let localDefs = builderDefs.meta.function { 
	  src = 
		fetchurl {
			url = mirror://sourceforge/audacity/audacity-src-1.3.3.tar.gz;
			sha256 = "17bjc2rnqspg1mbay4b1hhgg08iadapwf6w98gbv3r84rv1mhgls";
		};

  	buildInputs =[(wxGTK null) libogg libvorbis libsndfile libmad pkgconfig gtk 
		gettext glib];
	};
	in with localDefs;
let 
	postInstall = FullDepEntry ("
		old_rpath=$(patchelf --print-rpath \$out/bin/audacity);
		patchelf --set-rpath \$old_rpath:${gtk}/lib:${glib}/lib \$out/bin/audacity;
	") [minInit];
	preBuild = FullDepEntry ("
		sed -e '/\\/usr\\/local\\/lib\\/ladspa/awxGetApp()."+
			"AddUniquePathToPathList(wxGetenv(wxT(\"HOME\"))+"+
			"wxT(\"/.ladspa-plugins\"), pathList);'

	") [minInit];
in
stdenv.mkDerivation {
  name = "audacity-1.3.3";

  builder = writeScript "audacity-1.3.3-builder"
		(textClosure localDefs [addInputs (doDump "0") (noDepEntry "echo \$PATH; ar --version") doConfigure preBuild doMakeInstall postInstall doForceShare]);

  meta = {
    description = "Audacity sound editor.";
    homepage = http://audacity.sourceforge.net;
    inherit src;
  };
}
