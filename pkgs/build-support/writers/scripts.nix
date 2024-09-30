{
  buildPackages,
  gixy,
  lib,
  libiconv,
  makeBinaryWrapper,
  mkNugetDeps,
  mkNugetSource,
  pkgs,
  stdenv,
}:
let
  inherit (lib)
    concatMapStringsSep
    elem
    escapeShellArg
    last
    optionalString
    strings
    types
    ;
in
rec {
  /**
    `makeScriptWriter` returns a derivation which creates an executable script.

    # Inputs

    config (AttrSet)
    : `interpreter` (String)
      : the [interpreter](https://en.wikipedia.org/wiki/Shebang_(Unix)) to use for the script.
    : `check` (String)
      : A command to check the script. For example, this could be a linting check.
    : `makeWrapperArgs` (Optional, [ String ], Default: [])
      : Arguments forwarded to (`makeWrapper`)[#fun-makeWrapper].

    `nameOrPath` (String)
    : The name of the script or the path to the script.

      When a `string` starting with "/" is passed, the script will be created at the specified path in $out.
      I.e. `"/bin/hello"` will create a script at `$out/bin/hello`.

      Any other `string` is interpreted as a filename.
      It must be a [POSIX filename](https://en.wikipedia.org/wiki/Filename) starting with a letter, digit, dot, or underscore.
      Spaces or special characters are not allowed.

    `content` (String)
    : The content of the script.

    :::{.note}
    This function is used as base implementation for other high-level writer functions.

    For example, `writeBash` can (roughly) be implemented as:

    ```nix
    writeBash = makeScriptWriter { interpreter = "${pkgs.bash}/bin/bash"; }
    ```
    :::

    # Examples
    :::{.example}
    ## `pkgs.writers.makeScriptWriter` dash example

    ```nix-repl
    :b makeScriptWriter { interpreter = "${pkgs.dash}/bin/dash"; } "hello" "echo hello world"
    -> /nix/store/indvlr9ckmnv4f0ynkmasv2h4fxhand0-hello
    ```

    The above example creates a script named `hello` that outputs `hello world` when executed.

    ```sh
    > /nix/store/indvlr9ckmnv4f0ynkmasv2h4fxhand0-hello
    hello world
    ```
    :::

    :::{.example}
    ## `pkgs.writers.makeScriptWriter` python example

    ```nix-repl
    :b makeScriptWriter { interpreter = "${pkgs.python3}/bin/python"; } "python-hello" "print('hello world')"
    -> /nix/store/4kvby1hqr45ffcdrvfpnpj62hanskw93-python-hello
    ```

    ```sh
    > /nix/store/4kvby1hqr45ffcdrvfpnpj62hanskw93-python-hello
    hello world
    ```
    :::
  */
  makeScriptWriter =
    {
      interpreter,
      check ? "",
      makeWrapperArgs ? [ ],
    }:
    nameOrPath: content:
    assert
      (types.path.check nameOrPath)
      || (builtins.match "([0-9A-Za-z._])[0-9A-Za-z._-]*" nameOrPath != null);
    assert (types.path.check content) || (types.str.check content);
    let
      nameIsPath = types.path.check nameOrPath;
      name = last (builtins.split "/" nameOrPath);
      path = if nameIsPath then nameOrPath else "/bin/${name}";
      # The inner derivation which creates the executable under $out/bin (never at $out directly)
      # This is required in order to support wrapping, as wrapped programs consist of
      # at least two files: the executable and the wrapper.
      inner =
        pkgs.runCommandLocal name
          (
            {
              inherit makeWrapperArgs;
              nativeBuildInputs = [ makeBinaryWrapper ];
              meta.mainProgram = name;
            }
            // (
              if (types.str.check content) then
                {
                  inherit content interpreter;
                  passAsFile = [ "content" ];
                }
              else
                {
                  inherit interpreter;
                  contentPath = content;
                }
            )
          )
          ''
            # On darwin a script cannot be used as an interpreter in a shebang but
            # there doesn't seem to be a limit to the size of shebang and multiple
            # arguments to the interpreter are allowed.
            if [[ -n "${toString pkgs.stdenvNoCC.hostPlatform.isDarwin}" ]] && isScript $interpreter
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

            # Relocate executable
            # Wrap it if makeWrapperArgs are specified
            mv $out tmp
              mkdir -p $out/$(dirname "${path}")
              mv tmp $out/${path}
            if [ -n "''${makeWrapperArgs+''${makeWrapperArgs[@]}}" ]; then
                wrapProgram $out/${path} ''${makeWrapperArgs[@]}
            fi
          '';
    in
    if nameIsPath then
      inner
    # In case nameOrPath is a name, the user intends the executable to be located at $out.
    # This is achieved by creating a separate derivation containing a symlink at $out linking to ${inner}/bin/${name}.
    # This breaks the override pattern.
    # In case this turns out to be a problem, we can still add more magic
    else
      pkgs.runCommandLocal name { } ''
        ln -s ${inner}/bin/${name} $out
      '';

  /**
    `makeBinWriter` returns a derivation which compiles the given script into an executable format.

    :::{.note}
    This function is the base implementation for other compile language `writers`, such as `writeHaskell` and `writeRust`.
    :::

    # Inputs

    config (AttrSet)
    : `compileScript` (String)
      : The script that compiles the given content into an executable.

    : `strip` (Boolean, Default: true)
      : Whether to [strip](https://nixos.org/manual/nixpkgs/stable/#ssec-fixup-phase) the executable or not.

    : `makeWrapperArgs` (Optional, [ String ], Default: [])
      : Arguments forwarded to (`makeWrapper`)[#fun-makeWrapper]

    `nameOrPath` (String)
    : The name of the script or the path to the script.

      When a `string` starting with "/" is passed, the script will be created at the specified path in $out.
      For example, `"/bin/hello"` will create a script at `$out/bin/hello`.

      Any other `string` is interpreted as a filename.
      It must be a [POSIX filename](https://en.wikipedia.org/wiki/Filename) starting with a letter, digit, dot, or underscore.
      Spaces or special characters are not allowed.

    # Examples
    :::{.example}
    ## `pkgs.writers.makeBinWriter` example

    ```c
    // main.c
    #include <stdio.h>

    int main()
    {
        printf("Hello, World!\n");
        return 0;
    }
    ```

    ```nix-repl
    :b makeBinWriter { compileScript = "${pkgs.gcc}/bin/gcc -o $out $contentPath"; } "hello" ./main.c
    out -> /nix/store/f6crc8mwj3lvcxqclw7n09cm8nb6kxbh-hello
    ```

    The above example creates an executable named `hello` that outputs `Hello, World!` when executed.

    ```sh
    > /nix/store/f6crc8mwj3lvcxqclw7n09cm8nb6kxbh-hello
    Hello, World!
    ```
    :::
  */
  makeBinWriter =
    {
      compileScript,
      strip ? true,
      makeWrapperArgs ? [ ],
    }:
    nameOrPath: content:
    assert
      (types.path.check nameOrPath)
      || (builtins.match "([0-9A-Za-z._])[0-9A-Za-z._-]*" nameOrPath != null);
    assert (types.path.check content) || (types.str.check content);
    let
      nameIsPath = types.path.check nameOrPath;
      name = last (builtins.split "/" nameOrPath);
      path = if nameIsPath then nameOrPath else "/bin/${name}";
      # The inner derivation which creates the executable under $out/bin (never at $out directly)
      # This is required in order to support wrapping, as wrapped programs consist of at least two files: the executable and the wrapper.
      inner =
        pkgs.runCommandLocal name
          (
            {
              inherit makeWrapperArgs;
              nativeBuildInputs = [ makeBinaryWrapper ];
              meta.mainProgram = name;
            }
            // (
              if (types.str.check content) then
                {
                  inherit content;
                  passAsFile = [ "content" ];
                }
              else
                { contentPath = content; }
            )
          )
          ''
            ${compileScript}
            ${lib.optionalString strip "${lib.getBin buildPackages.bintools-unwrapped}/bin/${buildPackages.bintools-unwrapped.targetPrefix}strip -S $out"}
            # Sometimes binaries produced for darwin (e. g. by GHC) won't be valid
            # mach-o executables from the get-go, but need to be corrected somehow
            # which is done by fixupPhase.
            ${lib.optionalString pkgs.stdenvNoCC.hostPlatform.isDarwin "fixupPhase"}
            mv $out tmp
            mkdir -p $out/$(dirname "${path}")
            mv tmp $out/${path}
            if [ -n "''${makeWrapperArgs+''${makeWrapperArgs[@]}}" ]; then
              wrapProgram $out/${path} ''${makeWrapperArgs[@]}
            fi
          '';
    in
    if nameIsPath then
      inner
    # In case nameOrPath is a name, the user intends the executable to be located at $out.
    # This is achieved by creating a separate derivation containing a symlink at $out linking to ${inner}/bin/${name}.
    # This breaks the override pattern.
    # In case this turns out to be a problem, we can still add more magic
    else
      pkgs.runCommandLocal name { } ''
        ln -s ${inner}/bin/${name} $out
      '';

  /**
    Like writeScript but the first line is a shebang to bash
    Can be called with or without extra arguments.

    # Examples
    :::{.example}

    ## Without arguments

    ```nix
    writeBash "example" ''
    echo hello world
    ''
    ```

    ## With arguments

    ```nix
    writeBash "example"
    {
      makeWrapperArgs = [
        "--prefix" "PATH" ":" "${lib.makeBinPath [ pkgs.hello ]}"
      ];
    }
    ''
      hello
    ''
    ```
    :::
  */
  writeBash =
    name: argsOrScript:
    if lib.isAttrs argsOrScript && !lib.isDerivation argsOrScript then
      makeScriptWriter (argsOrScript // { interpreter = "${lib.getExe pkgs.bash}"; }) name
    else
      makeScriptWriter { interpreter = "${lib.getExe pkgs.bash}"; } name argsOrScript;

  /**
    Like writeScriptBin but the first line is a shebang to bash

    Can be called with or without extra arguments.

    ## Examples
    :::{.example}
    ## `pkgs.writers.writeBashBin` example without arguments

    ```nix
    writeBashBin "example" ''
      echo hello world
    ''
    ```
    :::

    :::{.example}
    ## `pkgs.writers.writeBashBin` example with arguments

    ```nix
    writeBashBin "example"
    {
      makeWrapperArgs = [
        "--prefix" "PATH" ":" "${lib.makeBinPath [ pkgs.hello ]}"
      ];
    }
    ''
      hello
    ''
    ```
    :::
  */
  writeBashBin = name: writeBash "/bin/${name}";

  /**
    Like writeScript but the first line is a shebang to dash

    Can be called with or without extra arguments.

    # Example
    :::{.example}
    ## `pkgs.writers.writeDash` example without arguments

    ```nix
    writeDash "example" ''
      echo hello world
    ''
    ```
    :::

    :::{.example}
    ## `pkgs.writers.writeDash` example with arguments

    ```nix
    writeDash "example"
    {
      makeWrapperArgs = [
        "--prefix" "PATH" ":" "${lib.makeBinPath [ pkgs.hello ]}"
      ];
    }
    ''
      hello
    ''
    ```
    :::
  */
  writeDash =
    name: argsOrScript:
    if lib.isAttrs argsOrScript && !lib.isDerivation argsOrScript then
      makeScriptWriter (argsOrScript // { interpreter = "${lib.getExe pkgs.dash}"; }) name
    else
      makeScriptWriter { interpreter = "${lib.getExe pkgs.dash}"; } name argsOrScript;

  /**
    Like writeScriptBin but the first line is a shebang to dash

    Can be called with or without extra arguments.

    # Examples
    :::{.example}
    ## `pkgs.writers.writeDashBin` without arguments

    ```nix
    writeDashBin "example" ''
      echo hello world
    ''
    ```
    :::

    :::{.example}
    ## `pkgs.writers.writeDashBin` with arguments

    ```nix
    writeDashBin "example"
    {
      makeWrapperArgs = [
        "--prefix" "PATH" ":" "${lib.makeBinPath [ pkgs.hello ]}"
      ];
    }
    ''
      hello
    ''
    ```
    :::
  */
  writeDashBin = name: writeDash "/bin/${name}";

  /**
    Like writeScript but the first line is a shebang to fish

    Can be called with or without extra arguments.

    :::{.example}
    ## `pkgs.writers.writeFish` without arguments

    ```nix
    writeFish "example" ''
      echo hello world
    ''
    ```
    :::

    :::{.example}
    ## `pkgs.writers.writeFish` with arguments

    ```nix
    writeFish "example"
    {
      makeWrapperArgs = [
        "--prefix" "PATH" ":" "${lib.makeBinPath [ pkgs.hello ]}"
      ];
    }
    ''
      hello
    ''
    ```
    :::
  */
  writeFish =
    name: argsOrScript:
    if lib.isAttrs argsOrScript && !lib.isDerivation argsOrScript then
      makeScriptWriter (
        argsOrScript
        // {
          interpreter = "${lib.getExe pkgs.fish} --no-config";
          check = "${lib.getExe pkgs.fish} --no-config --no-execute"; # syntax check only
        }
      ) name
    else
      makeScriptWriter {
        interpreter = "${lib.getExe pkgs.fish} --no-config";
        check = "${lib.getExe pkgs.fish} --no-config --no-execute"; # syntax check only
      } name argsOrScript;

  /**
    Like writeScriptBin but the first line is a shebang to fish

    Can be called with or without extra arguments.

    # Examples
    :::{.example}
    ## `pkgs.writers.writeFishBin` without arguments

    ```nix
    writeFishBin "example" ''
      echo hello world
    ''
    ```
    :::

    :::{.example}
    ## `pkgs.writers.writeFishBin` with arguments

    ```nix
    writeFishBin "example"
    {
      makeWrapperArgs = [
        "--prefix" "PATH" ":" "${lib.makeBinPath [ pkgs.hello ]}"
      ];
    }
    ''
      hello
    ''
    ```
    :::
  */
  writeFishBin = name: writeFish "/bin/${name}";

  /**
    writeHaskell takes a name, an attrset with libraries and haskell version (both optional)
    and some haskell source code and returns an executable.

    # Examples
    :::{.example}
    ## `pkgs.writers.writeHaskell` usage example

    ```nix
    writeHaskell "missiles" { libraries = [ pkgs.haskellPackages.acme-missiles ]; } ''
      import Acme.Missiles

      main = launchMissiles
    '';
    ```
    :::
  */
  writeHaskell =
    name:
    {
      ghc ? pkgs.ghc,
      ghcArgs ? [ ],
      libraries ? [ ],
      makeWrapperArgs ? [ ],
      strip ? true,
      threadedRuntime ? true,
    }:
    let
      appendIfNotSet = el: list: if elem el list then list else list ++ [ el ];
      ghcArgs' = if threadedRuntime then appendIfNotSet "-threaded" ghcArgs else ghcArgs;

    in
    makeBinWriter {
      compileScript = ''
        cp $contentPath tmp.hs
        ${(ghc.withPackages (_: libraries))}/bin/ghc ${lib.escapeShellArgs ghcArgs'} tmp.hs
        mv tmp $out
      '';
      inherit makeWrapperArgs strip;
    } name;

  /**
    writeHaskellBin takes the same arguments as writeHaskell but outputs a directory (like writeScriptBin)
  */
  writeHaskellBin = name: writeHaskell "/bin/${name}";

  /**
    Like writeScript but the first line is a shebang to nu

    Can be called with or without extra arguments.

    # Examples
    :::{.example}
    ## `pkgs.writers.writeNu` without arguments

    ```nix
    writeNu "example" ''
      echo hello world
    ''
    ```
    :::

    :::{.example}
    ## `pkgs.writers.writeNu` with arguments

    ```nix
    writeNu "example"
      {
        makeWrapperArgs = [
          "--prefix" "PATH" ":" "${lib.makeBinPath [ pkgs.hello ]}"
        ];
      }
      ''
        hello
      ''
    ```
    :::
  */
  writeNu =
    name: argsOrScript:
    if lib.isAttrs argsOrScript && !lib.isDerivation argsOrScript then
      makeScriptWriter (
        argsOrScript // { interpreter = "${lib.getExe pkgs.nushell} --no-config-file"; }
      ) name
    else
      makeScriptWriter { interpreter = "${lib.getExe pkgs.nushell} --no-config-file"; } name argsOrScript;

  /**
    Like writeScriptBin but the first line is a shebang to nu

    Can be called with or without extra arguments.

    # Examples
    :::{.example}
    ## `pkgs.writers.writeNuBin` without arguments

    ```nix
    writeNuBin "example" ''
      echo hello world
    ''
    ```
    :::

    :::{.example}
    ## `pkgs.writers.writeNuBin` with arguments

    ```nix
    writeNuBin "example"
      {
        makeWrapperArgs = [
          "--prefix" "PATH" ":" "${lib.makeBinPath [ pkgs.hello ]}"
        ];
      }
      ''
        hello
      ''
    ```
    :::
  */
  writeNuBin = name: writeNu "/bin/${name}";

  /**
    makeRubyWriter takes ruby and compatible rubyPackages and produces ruby script writer,
    If any libraries are specified, ruby.withPackages is used as interpreter, otherwise the "bare" ruby is used.
  */
  makeRubyWriter =
    ruby: rubyPackages: buildRubyPackages: name:
    {
      libraries ? [ ],
      ...
    }@args:
    makeScriptWriter (
      (builtins.removeAttrs args [ "libraries" ])
      // {
        interpreter =
          if libraries == [ ] then "${ruby}/bin/ruby" else "${(ruby.withPackages (ps: libraries))}/bin/ruby";
        # Rubocop doesn't seem to like running in this fashion.
        #check = (writeDash "rubocop.sh" ''
        #  exec ${lib.getExe buildRubyPackages.rubocop} "$1"
        #'');
      }
    ) name;

  /**
    Like writeScript but the first line is a shebang to ruby

    # Examples
    :::{.example}
    ## `pkgs.writers.writeRuby` usage example

    ```nix
    writeRuby "example" { libraries = [ pkgs.rubyPackages.git ]; } ''
     puts "hello world"
    ''
    ```

    :::
  */
  writeRuby = makeRubyWriter pkgs.ruby pkgs.rubyPackages buildPackages.rubyPackages;

  writeRubyBin = name: writeRuby "/bin/${name}";

  /**
    makeLuaWriter takes lua and compatible luaPackages and produces lua script writer,
    which validates the script with luacheck at build time. If any libraries are specified,
    lua.withPackages is used as interpreter, otherwise the "bare" lua is used.
  */
  makeLuaWriter =
    lua: luaPackages: buildLuaPackages: name:
    {
      libraries ? [ ],
      ...
    }@args:
    makeScriptWriter (
      (builtins.removeAttrs args [ "libraries" ])
      // {
        interpreter = lua.interpreter;
        # if libraries == []
        # then lua.interpreter
        # else (lua.withPackages (ps: libraries)).interpreter
        # This should support packages! I just cant figure out why some dependency collision happens whenever I try to run this.
        check = (
          writeDash "luacheck.sh" ''
            exec ${buildLuaPackages.luacheck}/bin/luacheck "$1"
          ''
        );
      }
    ) name;

  /**
    writeLua takes a name an attributeset with libraries and some lua source code and
    returns an executable (should also work with luajit)

    # Examples
    :::{.example}
    ## `pkgs.writers.writeLua` usage example

    ```nix
    writeLua "test_lua" { libraries = [ pkgs.luaPackages.say ]; } ''
      s = require("say")
      s:set_namespace("en")

      s:set('money', 'I have %s dollars')
      s:set('wow', 'So much money!')

      print(s('money', {1000})) -- I have 1000 dollars

      s:set_namespace("fr") -- switch to french!
      s:set('wow', "Tant d'argent!")

      print(s('wow')) -- Tant d'argent!
      s:set_namespace("en")  -- switch back to english!
      print(s('wow')) -- So much money!
    ''
    ```

    :::
  */
  writeLua = makeLuaWriter pkgs.lua pkgs.luaPackages buildPackages.luaPackages;

  writeLuaBin = name: writeLua "/bin/${name}";

  writeRust =
    name:
    {
      makeWrapperArgs ? [ ],
      rustc ? pkgs.rustc,
      rustcArgs ? [ ],
      strip ? true,
    }:
    let
      darwinArgs = lib.optionals stdenv.hostPlatform.isDarwin [ "-L${lib.getLib libiconv}/lib" ];
    in
    makeBinWriter {
      compileScript = ''
        cp "$contentPath" tmp.rs
        PATH=${lib.makeBinPath [ pkgs.gcc ]} ${rustc}/bin/rustc ${lib.escapeShellArgs rustcArgs} ${lib.escapeShellArgs darwinArgs} -o "$out" tmp.rs
      '';
      inherit makeWrapperArgs strip;
    } name;

  writeRustBin = name: writeRust "/bin/${name}";

  /**
    writeJS takes a name an attributeset with libraries and some JavaScript sourcecode and
    returns an executable

    # Inputs

    `name`

    : 1\. Function argument

    `attrs`

    : 2\. Function argument

    `content`

    : 3\. Function argument

    # Examples
    :::{.example}
    ## `pkgs.writers.writeJS` usage example

    ```nix
    writeJS "example" { libraries = [ pkgs.uglify-js ]; } ''
      var UglifyJS = require("uglify-js");
      var code = "function add(first, second) { return first + second; }";
      var result = UglifyJS.minify(code);
      console.log(result.code);
    ''
    ```

    :::
  */
  writeJS =
    name:
    {
      libraries ? [ ],
    }:
    content:
    let
      node-env = pkgs.buildEnv {
        name = "node";
        paths = libraries;
        pathsToLink = [ "/lib/node_modules" ];
      };
    in
    writeDash name ''
      export NODE_PATH=${node-env}/lib/node_modules
      exec ${lib.getExe pkgs.nodejs} ${pkgs.writeText "js" content} "$@"
    '';

  /**
    writeJSBin takes the same arguments as writeJS but outputs a directory (like writeScriptBin)
  */
  writeJSBin = name: writeJS "/bin/${name}";

  awkFormatNginx = builtins.toFile "awkFormat-nginx.awk" ''
    awk -f
    {sub(/^[ \t]+/,"");idx=0}
    /\{/{ctx++;idx=1}
    /\}/{ctx--}
    {id="";for(i=idx;i<ctx;i++)id=sprintf("%s%s", id, "\t");printf "%s%s\n", id, $0}
  '';

  writeNginxConfig =
    name: text:
    pkgs.runCommandLocal name
      {
        inherit text;
        passAsFile = [ "text" ];
        nativeBuildInputs = [ gixy ];
      } # sh
      ''
        # nginx-config-formatter has an error - https://github.com/1connect/nginx-config-formatter/issues/16
        awk -f ${awkFormatNginx} "$textPath" | sed '/^\s*$/d' > $out
        gixy $out
      '';

  /**
    writePerl takes a name an attributeset with libraries and some perl sourcecode and
    returns an executable

    # Examples
    :::{.example}
    ## `pkgs.writers.writePerl` usage example

    ```nix
    writePerl "example" { libraries = [ pkgs.perlPackages.boolean ]; } ''
      use boolean;
      print "Howdy!\n" if true;
    ''
    ```

    :::
  */
  writePerl =
    name:
    {
      libraries ? [ ],
      ...
    }@args:
    makeScriptWriter (
      (builtins.removeAttrs args [ "libraries" ])
      // {
        interpreter = "${lib.getExe (pkgs.perl.withPackages (p: libraries))}";
      }
    ) name;

  /**
    writePerlBin takes the same arguments as writePerl but outputs a directory (like writeScriptBin)
  */
  writePerlBin = name: writePerl "/bin/${name}";

  /**
    makePythonWriter takes python and compatible pythonPackages and produces python script writer,
    which validates the script with flake8 at build time. If any libraries are specified,
    python.withPackages is used as interpreter, otherwise the "bare" python is used.

    # Inputs

    `python`

    : 1\. Function argument

    `pythonPackages`

    : 2\. Function argument

    `buildPythonPackages`

    : 3\. Function argument

    `name`

    : 4\. Function argument

    `attrs`

    : 5\. Function argument
  */
  makePythonWriter =
    python: pythonPackages: buildPythonPackages: name:
    {
      libraries ? [ ],
      flakeIgnore ? [ ],
      doCheck ? true,
      ...
    }@args:
    let
      ignoreAttribute =
        optionalString (flakeIgnore != [ ])
          "--ignore ${concatMapStringsSep "," escapeShellArg flakeIgnore}";
    in
    makeScriptWriter (
      (builtins.removeAttrs args [
        "libraries"
        "flakeIgnore"
        "doCheck"
      ])
      // {
        interpreter =
          if pythonPackages != pkgs.pypy2Packages || pythonPackages != pkgs.pypy3Packages then
            if libraries == [ ] then python.interpreter else (python.withPackages (ps: libraries)).interpreter
          else
            python.interpreter;
        check = optionalString (python.isPy3k && doCheck) (
          writeDash "pythoncheck.sh" ''
            exec ${buildPythonPackages.flake8}/bin/flake8 --show-source ${ignoreAttribute} "$1"
          ''
        );
      }
    ) name;

  /**
    writePyPy2 takes a name an attributeset with libraries and some pypy2 sourcecode and
    returns an executable

    # Examples
    :::{.example}
    ## `pkgs.writers.writePyPy2` usage example

    ```nix
    writePyPy2 "test_pypy2" { libraries = [ pkgs.pypy2Packages.enum ]; } ''
      from enum import Enum

      class Test(Enum):
          a = "success"

      print Test.a
    ''
    ```

    :::
  */
  writePyPy2 = makePythonWriter pkgs.pypy2 pkgs.pypy2Packages buildPackages.pypy2Packages;

  /**
    writePyPy2Bin takes the same arguments as writePyPy2 but outputs a directory (like writeScriptBin)
  */
  writePyPy2Bin = name: writePyPy2 "/bin/${name}";

  /**
    writePython3 takes a name an attributeset with libraries and some python3 sourcecode and
    returns an executable

    # Examples
    :::{.example}
    ## `pkgs.writers.writePython3` usage example

    ```nix
    writePython3 "test_python3" { libraries = [ pkgs.python3Packages.pyyaml ]; } ''
      import yaml

      y = yaml.safe_load("""
        - test: success
      """)
      print(y[0]['test'])
    ''
    ```

    :::
  */
  writePython3 = makePythonWriter pkgs.python3 pkgs.python3Packages buildPackages.python3Packages;

  # writePython3Bin takes the same arguments as writePython3 but outputs a directory (like writeScriptBin)
  writePython3Bin = name: writePython3 "/bin/${name}";

  /**
    writePyPy3 takes a name an attributeset with libraries and some pypy3 sourcecode and
    returns an executable

    # Examples
    :::{.example}
    ## `pkgs.writers.writePyPy3` usage example

    ```nix
    writePyPy3 "test_pypy3" { libraries = [ pkgs.pypy3Packages.pyyaml ]; } ''
      import yaml

      y = yaml.safe_load("""
        - test: success
      """)
      print(y[0]['test'])
    ''
    ```

    :::
  */
  writePyPy3 = makePythonWriter pkgs.pypy3 pkgs.pypy3Packages buildPackages.pypy3Packages;

  /**
    writePyPy3Bin takes the same arguments as writePyPy3 but outputs a directory (like writeScriptBin)
  */
  writePyPy3Bin = name: writePyPy3 "/bin/${name}";

  makeFSharpWriter =
    {
      dotnet-sdk ? pkgs.dotnet-sdk,
      fsi-flags ? "",
      libraries ? _: [ ],
      ...
    }@args:
    nameOrPath:
    let
      fname = last (builtins.split "/" nameOrPath);
      path = if strings.hasSuffix ".fsx" nameOrPath then nameOrPath else "${nameOrPath}.fsx";
      _nugetDeps = mkNugetDeps {
        name = "${fname}-nuget-deps";
        nugetDeps = libraries;
      };

      nuget-source = mkNugetSource {
        name = "${fname}-nuget-source";
        description = "Nuget source with the dependencies for ${fname}";
        deps = [ _nugetDeps ];
      };

      fsi = writeBash "fsi" ''
        export HOME=$NIX_BUILD_TOP/.home
        export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1
        export DOTNET_CLI_TELEMETRY_OPTOUT=1
        export DOTNET_NOLOGO=1
        script="$1"; shift
        ${lib.getExe dotnet-sdk} fsi --quiet --nologo --readline- ${fsi-flags} "$@" < "$script"
      '';

    in
    content:
    makeScriptWriter
      (
        (builtins.removeAttrs args [
          "dotnet-sdk"
          "fsi-flags"
          "libraries"
        ])
        // {
          interpreter = fsi;
        }
      )
      path
      ''
        #i "nuget: ${nuget-source}/lib"
        ${content}
        exit 0
      '';

  writeFSharp = makeFSharpWriter { };

  writeFSharpBin = name: writeFSharp "/bin/${name}";
}
