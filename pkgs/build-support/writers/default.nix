{ pkgs, config, buildPackages, lib, stdenv, libiconv, mkNugetDeps, mkNugetSource, gawk, gnused, gixy }:

let
  aliases = if (config.allowAliases or true) then (import ./aliases.nix lib) else prev: {};

  writers = with lib; rec {
  # Base implementation for non-compiled executables.
  # Takes an interpreter, for example `${pkgs.bash}/bin/bash`
  #
  # Examples:
  #   writeBash = makeScriptWriter { interpreter = "${pkgs.bash}/bin/bash"; }
  #   makeScriptWriter { interpreter = "${pkgs.dash}/bin/dash"; } "hello" "echo hello world"
  makeScriptWriter = { interpreter, check ? "" }: nameOrPath: content:
    assert lib.or (types.path.check nameOrPath) (builtins.match "([0-9A-Za-z._])[0-9A-Za-z._-]*" nameOrPath != null);
    assert lib.or (types.path.check content) (types.str.check content);
    let
      name = last (builtins.split "/" nameOrPath);
    in

    pkgs.runCommandLocal name (if (types.str.check content) then {
      inherit content interpreter;
      passAsFile = [ "content" ];
    } else {
      inherit interpreter;
      contentPath = content;
    }) ''
      # On darwin a script cannot be used as an interpreter in a shebang but
      # there doesn't seem to be a limit to the size of shebang and multiple
      # arguments to the interpreter are allowed.
      if [[ -n "${toString pkgs.stdenvNoCC.isDarwin}" ]] && isScript $interpreter
      then
        wrapperInterpreterLine=$(head -1 "$interpreter" | tail -c+3)
        # Get first word from the line (note: xargs echo remove leading spaces)
        wrapperInterpreter=$(echo "$wrapperInterpreterLine" | xargs echo | cut -d " " -f1)

        if isScript $wrapperInterpreter
        then
          echo "error: passed interpreter ($interpreter) is a script which has another script ($wrapperInterpreter) as an interpreter, which is not supported."
          exit 1
        fi

        # This should work as long as wrapperInterpreter is a shell, which is
        # the case for programs wrapped with makeWrapper, like
        # python3.withPackages etc.
        interpreterLine="$wrapperInterpreterLine $interpreter"
      else
        interpreterLine=$interpreter
      fi

      echo "#! $interpreterLine" > $out
      cat "$contentPath" >> $out
      ${optionalString (check != "") ''
        ${check} $out
      ''}
      chmod +x $out
      ${optionalString (types.path.check nameOrPath) ''
        mv $out tmp
        mkdir -p $out/$(dirname "${nameOrPath}")
        mv tmp $out/${nameOrPath}
      ''}
    '';

  # Base implementation for compiled executables.
  # Takes a compile script, which in turn takes the name as an argument.
  #
  # Examples:
  #   writeSimpleC = makeBinWriter { compileScript = name: "gcc -o $out $contentPath"; }
  makeBinWriter = { compileScript, strip ? true }: nameOrPath: content:
    assert lib.or (types.path.check nameOrPath) (builtins.match "([0-9A-Za-z._])[0-9A-Za-z._-]*" nameOrPath != null);
    assert lib.or (types.path.check content) (types.str.check content);
    let
      name = last (builtins.split "/" nameOrPath);
    in
    pkgs.runCommand name (if (types.str.check content) then {
      inherit content;
      passAsFile = [ "content" ];
    } else {
      contentPath = content;
    }) ''
      ${compileScript}
      ${lib.optionalString strip
          "${lib.getBin buildPackages.bintools-unwrapped}/bin/${buildPackages.bintools-unwrapped.targetPrefix}strip -S $out"}
      # Sometimes binaries produced for darwin (e. g. by GHC) won't be valid
      # mach-o executables from the get-go, but need to be corrected somehow
      # which is done by fixupPhase.
      ${lib.optionalString pkgs.stdenvNoCC.hostPlatform.isDarwin "fixupPhase"}
      ${optionalString (types.path.check nameOrPath) ''
        mv $out tmp
        mkdir -p $out/$(dirname "${nameOrPath}")
        mv tmp $out/${nameOrPath}
      ''}
    '';

  # Like writeScript but the first line is a shebang to bash
  #
  # Example:
  #   writeBash "example" ''
  #     echo hello world
  #   ''
  writeBash = makeScriptWriter {
    interpreter = "${pkgs.bash}/bin/bash";
  };

  # Like writeScriptBIn but the first line is a shebang to bash
  writeBashBin = name:
    writeBash "/bin/${name}";

  # Like writeScript but the first line is a shebang to dash
  #
  # Example:
  #   writeDash "example" ''
  #     echo hello world
  #   ''
  writeDash = makeScriptWriter {
    interpreter = "${pkgs.dash}/bin/dash";
  };

  # Like writeScriptBin but the first line is a shebang to dash
  writeDashBin = name:
    writeDash "/bin/${name}";

  # writeHaskell takes a name, an attrset with libraries and haskell version (both optional)
  # and some haskell source code and returns an executable.
  #
  # Example:
  #   writeHaskell "missiles" { libraries = [ pkgs.haskellPackages.acme-missiles ]; } ''
  #     import Acme.Missiles
  #
  #     main = launchMissiles
  #   '';
  writeHaskell = name: {
    libraries ? [],
    ghc ? pkgs.ghc,
    ghcArgs ? [],
    strip ? true
  }:
    makeBinWriter {
      compileScript = ''
        cp $contentPath tmp.hs
        ${ghc.withPackages (_: libraries )}/bin/ghc ${lib.escapeShellArgs ghcArgs} tmp.hs
        mv tmp $out
      '';
      inherit strip;
    } name;

  # writeHaskellBin takes the same arguments as writeHaskell but outputs a directory (like writeScriptBin)
  writeHaskellBin = name:
    writeHaskell "/bin/${name}";

  writeRust = name: {
      rustc ? pkgs.rustc,
      rustcArgs ? [],
      strip ? true
  }:
  let
    darwinArgs = lib.optionals stdenv.isDarwin [ "-L${lib.getLib libiconv}/lib" ];
  in
    makeBinWriter {
      compileScript = ''
        cp "$contentPath" tmp.rs
        PATH=${makeBinPath [pkgs.gcc]} ${lib.getBin rustc}/bin/rustc ${lib.escapeShellArgs rustcArgs} ${lib.escapeShellArgs darwinArgs} -o "$out" tmp.rs
      '';
      inherit strip;
    } name;

  writeRustBin = name:
    writeRust "/bin/${name}";

  # writeJS takes a name an attributeset with libraries and some JavaScript sourcecode and
  # returns an executable
  #
  # Example:
  #   writeJS "example" { libraries = [ pkgs.nodePackages.uglify-js ]; } ''
  #     var UglifyJS = require("uglify-js");
  #     var code = "function add(first, second) { return first + second; }";
  #     var result = UglifyJS.minify(code);
  #     console.log(result.code);
  #   ''
  writeJS = name: { libraries ? [] }: content:
  let
    node-env = pkgs.buildEnv {
      name = "node";
      paths = libraries;
      pathsToLink = [
        "/lib/node_modules"
      ];
    };
  in writeDash name ''
    export NODE_PATH=${node-env}/lib/node_modules
    exec ${pkgs.nodejs}/bin/node ${pkgs.writeText "js" content}
  '';

  # writeJSBin takes the same arguments as writeJS but outputs a directory (like writeScriptBin)
  writeJSBin = name:
    writeJS "/bin/${name}";

  awkFormatNginx = builtins.toFile "awkFormat-nginx.awk" ''
    awk -f
    {sub(/^[ \t]+/,"");idx=0}
    /\{/{ctx++;idx=1}
    /\}/{ctx--}
    {id="";for(i=idx;i<ctx;i++)id=sprintf("%s%s", id, "\t");printf "%s%s\n", id, $0}
   '';

  writeNginxConfig = name: text: pkgs.runCommandLocal name {
    inherit text;
    passAsFile = [ "text" ];
    nativeBuildInputs = [ gawk gnused gixy ];
  } /* sh */ ''
    # nginx-config-formatter has an error - https://github.com/1connect/nginx-config-formatter/issues/16
    awk -f ${awkFormatNginx} "$textPath" | sed '/^\s*$/d' > $out
    gixy $out
  '';

  # writePerl takes a name an attributeset with libraries and some perl sourcecode and
  # returns an executable
  #
  # Example:
  #   writePerl "example" { libraries = [ pkgs.perlPackages.boolean ]; } ''
  #     use boolean;
  #     print "Howdy!\n" if true;
  #   ''
  writePerl = name: { libraries ? [] }:
    makeScriptWriter {
      interpreter = "${pkgs.perl.withPackages (p: libraries)}/bin/perl";
    } name;

  # writePerlBin takes the same arguments as writePerl but outputs a directory (like writeScriptBin)
  writePerlBin = name:
    writePerl "/bin/${name}";

  # makePythonWriter takes python and compatible pythonPackages and produces python script writer,
  # which validates the script with flake8 at build time. If any libraries are specified,
  # python.withPackages is used as interpreter, otherwise the "bare" python is used.
  makePythonWriter = python: pythonPackages: name: { libraries ? [], flakeIgnore ? [] }:
  let
    ignoreAttribute = optionalString (flakeIgnore != []) "--ignore ${concatMapStringsSep "," escapeShellArg flakeIgnore}";
  in
  makeScriptWriter {
    interpreter =
      if libraries == []
      then "${python}/bin/python"
      else "${python.withPackages (ps: libraries)}/bin/python"
    ;
    check = optionalString python.isPy3k (writeDash "pythoncheck.sh" ''
      exec ${pythonPackages.flake8}/bin/flake8 --show-source ${ignoreAttribute} "$1"
    '');
  } name;

  # writePyPy2 takes a name an attributeset with libraries and some pypy2 sourcecode and
  # returns an executable
  #
  # Example:
  # writePyPy2 "test_pypy2" { libraries = [ pkgs.pypy2Packages.enum ]; } ''
  #   from enum import Enum
  #
  #   class Test(Enum):
  #       a = "success"
  #
  #   print Test.a
  # ''
  writePyPy2 = makePythonWriter pkgs.pypy2 pkgs.pypy2Packages;

  # writePyPy2Bin takes the same arguments as writePyPy2 but outputs a directory (like writeScriptBin)
  writePyPy2Bin = name:
    writePyPy2 "/bin/${name}";

  # writePython3 takes a name an attributeset with libraries and some python3 sourcecode and
  # returns an executable
  #
  # Example:
  # writePython3 "test_python3" { libraries = [ pkgs.python3Packages.pyyaml ]; } ''
  #   import yaml
  #
  #   y = yaml.load("""
  #     - test: success
  #   """)
  #   print(y[0]['test'])
  # ''
  writePython3 = makePythonWriter pkgs.python3 pkgs.python3Packages;

  # writePython3Bin takes the same arguments as writePython3 but outputs a directory (like writeScriptBin)
  writePython3Bin = name:
    writePython3 "/bin/${name}";

  # writePyPy3 takes a name an attributeset with libraries and some pypy3 sourcecode and
  # returns an executable
  #
  # Example:
  # writePyPy3 "test_pypy3" { libraries = [ pkgs.pypy3Packages.pyyaml ]; } ''
  #   import yaml
  #
  #   y = yaml.load("""
  #     - test: success
  #   """)
  #   print(y[0]['test'])
  # ''
  writePyPy3 = makePythonWriter pkgs.pypy3 pkgs.pypy3Packages;

  # writePyPy3Bin takes the same arguments as writePyPy3 but outputs a directory (like writeScriptBin)
  writePyPy3Bin = name:
    writePyPy3 "/bin/${name}";


  makeFSharpWriter = { dotnet-sdk ? pkgs.dotnet-sdk, fsi-flags ? "", libraries ? _: [] }: nameOrPath:
  let
    fname = last (builtins.split "/" nameOrPath);
    path = if strings.hasSuffix ".fsx" nameOrPath then nameOrPath else "${nameOrPath}.fsx";
    _nugetDeps = mkNugetDeps { name = "${fname}-nuget-deps"; nugetDeps = libraries; };

    nuget-source = mkNugetSource {
      name = "${fname}-nuget-source";
      description = "A Nuget source with the dependencies for ${fname}";
      deps = [ _nugetDeps ];
    };

    fsi = writeBash "fsi" ''
      export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1
      export DOTNET_CLI_TELEMETRY_OPTOUT=1
      export DOTNET_NOLOGO=1
      script="$1"; shift
      ${dotnet-sdk}/bin/dotnet fsi --quiet --nologo --readline- ${fsi-flags} "$@" < "$script"
    '';

  in content: writers.makeScriptWriter {
    interpreter = fsi;
  } path
  ''
    #i "nuget: ${nuget-source}/lib"
    ${ content }
    exit 0
  '';

  writeFSharp =
    makeFSharpWriter {};

  writeFSharpBin = name:
    writeFSharp "/bin/${name}";

};
in
writers // (aliases writers)
