args : with args;	
	let 
       	localDefs = with (builderDefs {src="";} null);
	 builderDefs {
		inherit src;
		buildInputs = [];
		configureFlags = [];
		makeFlags =  [];
		patch = null;
		meta = {};
		doInstall = if args ? Install then 
		(FullDepEntry 
		  args.Install 
		  (["doMake"] 
		  ++ (lib.getAttr ["extraInstallDeps"] [] args))
		)
		else FullDepEntry "" ["doMakeInstall"];

		debPatch = FullDepEntry ((if args ? patch then ''
		  gunzip < ${args.patch} | patch -Np1
		'' else "")
		+''
		  sed -e 's/-o root//' -i Makefile Makefile.in Makefile.new || true;
		  sed -e 's/-g root//' -i Makefile Makefile.in Makefile.new || true;
		''
		+ (if args ? extraReplacements then 
		  args.extraReplacements 
		else ""))["minInit" "doUnpack"];
	} args null; /* null is a terminator for sumArgs */
	in with localDefs;
stdenv.mkDerivation rec {
	name = localDefs.name + "deb";
	builder = writeScript (name + "-builder")
		(textClosure localDefs ([debPatch] ++ 
		(lib.optional (! (args ? omitConfigure)) "doConfigure")
		++ [doInstall doForceShare]));
	inherit meta;
}
