{stdenv, dotnetfx}:
{ name
, src
, baseDir ? "."
, slnFile
, targets ? "ReBuild"
, verbosity ? "detailed"
, options ? "/p:Configuration=Debug;Platform=Win32"
, assemblyInputs ? []
, preBuild ? ""
, wrapMain ? false
, namespace ? null
, mainClassName ? null
, mainClassFile ? null
}:

assert wrapMain -> namespace != null && mainClassName != null && mainClassFile != null;

let
  wrapperCS = ./Wrapper.cs.in;  
in
stdenv.mkDerivation {
  inherit name src;
  
  buildInputs = [ dotnetfx ];  

  preConfigure = ''
    cd ${baseDir}
  '';
  
  preBuild = ''
    ${preBuild}
    
    # Create wrapper class with main method
    ${stdenv.lib.optionalString wrapMain ''
      # Generate assemblySearchPaths string array contents
      for path in ${toString assemblyInputs}
      do
          assemblySearchArray="$assemblySearchPaths @\"$(cygpath --windows $path | sed 's|\\|\\\\|g')\""
      done

      sed -e "s|@NAMESPACE@|${namespace}|" \
          -e "s|@MAINCLASSNAME@|${mainClassName}|" \
	  -e "s|@ASSEMBLYSEARCHPATHS@|$assemblySearchArray|" \
          ${wrapperCS} > $(dirname ${mainClassFile})/${mainClassName}Wrapper.cs

      # Rename old main method and make it publically accessible
      # so that the wrapper can invoke it
      sed -i -e "s|static void Main|public static void Main2|g" ${mainClassFile}
      
      # Add the wrapper to the C# project file so that will be build as well
      find . -name \*.csproj | while read file
      do
          sed -i -e "s|$(basename ${mainClassFile})|$(basename ${mainClassFile});${mainClassName}Wrapper.cs|" "$file"
      done
    ''}
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
  '';
}
