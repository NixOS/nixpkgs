{dotnetenv}:

{ name
, src
, baseDir ? "."
, slnFile
, targets ? "ReBuild"
, verbosity ? "detailed"
, options ? "/p:Configuration=Debug;Platform=Win32"
, assemblyInputs ? []
, preBuild ? ""
, namespace
, mainClassName
, mainClassFile
, modifyPublicMain ? true
}:

let
  application = dotnetenv.buildSolution {
    inherit name src baseDir slnFile targets verbosity;
    inherit options assemblyInputs preBuild;
    inherit modifyPublicMain mainClassFile;
  };
in
dotnetenv.buildSolution {
  name = "${name}-wrapper";
  src = ./Wrapper;
  slnFile = "Wrapper.sln";
  assemblyInputs = [ application ];
  preBuild = ''
    export exePath=$(cygpath --windows $(find ${application} -name \*.exe) | sed 's|\\|\\\\|g')
    
    # Generate assemblySearchPaths string array contents
    for path in ${toString assemblyInputs}
    do
        assemblySearchArray="$assemblySearchArray @\"$(cygpath --windows $path | sed 's|\\|\\\\|g')\""
    done
    
    sed -e "s|@ROOTNAMESPACE@|${namespace}Wrapper|" \
        -e "s|@ASSEMBLYNAME@|${namespace}|" \
        Wrapper/Wrapper.csproj.in > Wrapper/Wrapper.csproj
    
    sed -e "s|@NAMESPACE@|${namespace}|g" \
        -e "s|@MAINCLASSNAME@|${mainClassName}|g" \
	-e "s|@EXEPATH@|$exePath|g" \
	-e "s|@ASSEMBLYSEARCHPATH@|$assemblySearchArray|" \
        Wrapper/Wrapper.cs.in > Wrapper/Wrapper.cs
  '';
}
