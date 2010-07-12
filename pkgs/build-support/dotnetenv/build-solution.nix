{stdenv, dotnetfx}:
{ name
, src
, baseDir ? "."
, slnFile
, targets ? "ReBuild"
, verbosity ? "detailed"
, options ? "/p:Configuration=Debug;Platform=Win32"
, assemblyInputs ? []
, runtimeAssemblies ? []
, preBuild ? ""
}:

stdenv.mkDerivation {
  inherit name src preBuild;  
  
  buildInputs = [ dotnetfx ];  
  preConfigure = ''
    cd ${baseDir}
  '';
  
  installPhase = ''        
    for i in ${toString assemblyInputs}
    do
	windowsPath=$(cygpath --windows $i) 
	echo "Using assembly path: $windowsPath"
	
	if [ "$assemblySearchPaths" = "" ]
	then
	    assemblySearchPaths="$windowsPath"
	else
	    assemblySearchPaths="$assemblySearchPaths;$windowsPath"
	fi
    done
      
    echo "Assembly search paths are: $assemblySearchPaths"
    
    if [ "$assemblySearchPaths" != "" ]
    then
	echo "Using assembly search paths args: $assemblySearchPathsArg"
	export AssemblySearchPaths=$assemblySearchPaths
    fi
    
    ensureDir $out
    MSBuild.exe ${toString slnFile} /nologo /t:${targets} /p:IntermediateOutputPath=$(cygpath --windows $out)\\ /p:OutputPath=$(cygpath --windows $out)\\ /verbosity:${verbosity} ${options}
    
    # Create references to runtime dependencies
    # !!! Should be more efficient (e.g. symlinking)
    
    for i in ${toString runtimeAssemblies}
    do
        cd $i
	
        for j in $(find . -type f)
	do
	    mkdir -p $out/$(dirname $j)
	    cp $j $out/$(dirname $j)
	done
    done
  '';
}
