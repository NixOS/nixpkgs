args : with args;	
	let 
       	localDefs = with (builderDefs.passthru.function {src="";});
	let 
	  checkFlag = flag : lib.attrByPath [flag] false args;
	in
	  builderDefs.passthru.function ({
		inherit src;
		inherit checkFlag;
		buildInputs = [];
		configureFlags = [];
		makeFlags = if (checkFlag "omitConfigure") 
		then [" PREFIX=$out "]
		else [];
		patch = null;
		meta = {};
		doInstall = if args ? Install then 
		(fullDepEntry 
		  args.Install 
		  (["doMake"] 
		  ++ (lib.attrByPath ["extraInstallDeps"] [] args))
		)
		else fullDepEntry "" ["doMakeInstall"];

		debPatch = fullDepEntry ((if args ? patch then ''
		  gunzip < ${args.patch} | patch -Np1
		'' else "")
		+''
		  sed -e 's/-o root//' -i Makefile Makefile.in Makefile.new || true;
		  sed -e 's/-g root//' -i Makefile Makefile.in Makefile.new || true;
		''
		+(if (checkFlag "omitFilePatches") then "" else 
		''
		  if test -d debian/patches; then 
		    for i in debian/patches/*; do 
		      patch -Np0 -i $i; 
		    done;
		  fi;
		'')
		+ (if args ? extraReplacements then 
		  args.extraReplacements 
		else ""))["minInit" "doUnpack"];
	}  // args);
	in with localDefs;
stdenv.mkDerivation rec {
	name = localDefs.name + "deb";
	builder = writeScript (name + "-builder")
		(textClosure localDefs ([debPatch] ++ 
		(lib.optional (patches != []) "doPatch") ++
		(lib.optional (! (checkFlag "omitConfigure")) "doConfigure") ++
    [doInstall doForceShare]));
	inherit meta;
	inherit src;
}
