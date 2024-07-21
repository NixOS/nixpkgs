{ lib, stdenv, dotnetfx }:
{ name
, src
, baseDir ? "."
, slnFile
, targets ? "ReBuild"
, verbosity ? "detailed"
, options ? "/p:Configuration=Debug;Platform=Win32"
, assemblyInputs ? []
, preBuild ? ""
, modifyPublicMain ? false
, mainClassFile ? null
}:

assert modifyPublicMain -> mainClassFile != null;

stdenv.mkDerivation {
  inherit name src;

  buildInputs = [ dotnetfx ];

  preConfigure = ''
    cd ${baseDir}
  '';

  preBuild = ''
    ${lib.optionalString modifyPublicMain ''
      sed -i -e "s|static void Main|public static void Main|" ${mainClassFile}
    ''}
    ${preBuild}
  '';

  installPhase = ''
    addDeps()
    {
	if [ -f $1/nix-support/dotnet-assemblies ]
	then
	    for i in $(cat $1/nix-support/dotnet-assemblies)
	    do
		windowsPath=$(cygpath --windows $i)
		assemblySearchPaths="$assemblySearchPaths;$windowsPath"

		addDeps $i
	    done
	fi
    }

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

	addDeps $i
    done

    echo "Assembly search paths are: $assemblySearchPaths"

    if [ "$assemblySearchPaths" != "" ]
    then
	echo "Using assembly search paths args: $assemblySearchPathsArg"
	export AssemblySearchPaths=$assemblySearchPaths
    fi

    mkdir -p $out
    MSBuild.exe ${toString slnFile} /nologo /t:${targets} /p:IntermediateOutputPath=$(cygpath --windows $out)\\ /p:OutputPath=$(cygpath --windows $out)\\ /verbosity:${verbosity} ${options}

    # Because .NET assemblies store strings as UTF-16 internally, we cannot detect
    # hashes. Therefore a text files containing the proper paths is created
    # We can also use this file the propagate transitive dependencies.

    mkdir -p $out/nix-support

    for i in ${toString assemblyInputs}
    do
        echo $i >> $out/nix-support/dotnet-assemblies
    done
  '';
}
