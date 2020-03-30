{ lib, stdenv, stdenvNoCC, lndir, runtimeShell }:

let

  runCommand' = runLocal: stdenv: name: env: buildCommand:
    stdenv.mkDerivation ({
      inherit name buildCommand;
      passAsFile = [ "buildCommand" ];
    }
    // (lib.optionalAttrs runLocal {
          preferLocalBuild = true;
          allowSubstitutes = false;
       })
    // env);

in

rec {

  /* Run the shell command `buildCommand' to produce a store path named
  * `name'.  The attributes in `env' are added to the environment
  * prior to running the command. By default `runCommand' runs using
  * stdenv with no compiler environment. `runCommandCC`
  *
  * Examples:
  * runCommand "name" {envVariable = true;} ''echo hello > $out''
  * runCommandNoCC "name" {envVariable = true;} ''echo hello > $out'' # equivalent to prior
  * runCommandCC "name" {} ''gcc -o myfile myfile.c; cp myfile $out'';
  *
  * The `*Local` variants force a derivation to be built locally,
  * it is not substituted.
  *
  * This is intended for very cheap commands (<1s execution time).
  * It saves on the network roundrip and can speed up a build.
  *
  * It is the same as adding the special fields
  * `preferLocalBuild = true;`
  * `allowSubstitutes = false;`
  * to a derivation’s attributes.
  */
  runCommand = runCommandNoCC;
  runCommandLocal = runCommandNoCCLocal;

  runCommandNoCC = runCommand' false stdenvNoCC;
  runCommandNoCCLocal = runCommand' true stdenvNoCC;

  runCommandCC = runCommand' false stdenv;
  # `runCommandCCLocal` left out on purpose.
  # We shouldn’t force the user to have a cc in scope.

  /* Writes a text file to the nix store.
   * The contents of text is added to the file in the store.
   *
   * Examples:
   * # Writes my-file to /nix/store/<store path>
   * writeTextFile {
   *   name = "my-file";
   *   text = ''
   *     Contents of File
   *   '';
   * }
   * # See also the `writeText` helper function below.
   *
   * # Writes executable my-file to /nix/store/<store path>/bin/my-file
   * writeTextFile {
   *   name = "my-file";
   *   text = ''
   *     Contents of File
   *   '';
   *   executable = true;
   *   destination = "/bin/my-file";
   * }
   */
  writeTextFile =
    { name # the name of the derivation
    , text
    , executable ? false # run chmod +x ?
    , destination ? ""   # relative path appended to $out eg "/bin/foo"
    , checkPhase ? ""    # syntax checks, e.g. for scripts
    }:
    runCommand name
      { inherit text executable;
        passAsFile = [ "text" ];
        # Pointless to do this on a remote machine.
        preferLocalBuild = true;
        allowSubstitutes = false;
      }
      ''
        n=$out${destination}
        mkdir -p "$(dirname "$n")"

        if [ -e "$textPath" ]; then
          mv "$textPath" "$n"
        else
          echo -n "$text" > "$n"
        fi

        ${checkPhase}

        (test -n "$executable" && chmod +x "$n") || true
      '';

  /*
   * Writes a text file to nix store with no optional parameters available.
   *
   * Example:
   * # Writes contents of file to /nix/store/<store path>
   * writeText "my-file"
   *   ''
   *   Contents of File
   *   '';
   *
  */
  writeText = name: text: writeTextFile {inherit name text;};

  /*
   * Writes a text file to nix store in a specific directory with no
   * optional parameters available.
   *
   * Example:
   * # Writes contents of file to /nix/store/<store path>/share/my-file
   * writeTextDir "share/my-file"
   *   ''
   *   Contents of File
   *   '';
   *
  */
  writeTextDir = path: text: writeTextFile {
    inherit text;
    name = builtins.baseNameOf path;
    destination = "/${path}";
  };

  /*
   * Writes a text file to /nix/store/<store path> and marks the file as
   * executable.
   *
   * If passed as a build input, will be used as a setup hook. This makes setup
   * hooks more efficient to create: you don't need a derivation that copies
   * them to $out/nix-support/setup-hook, instead you can use the file as is.
   *
   * Example:
   * # Writes my-file to /nix/store/<store path> and makes executable
   * writeScript "my-file"
   *   ''
   *   Contents of File
   *   '';
   *
  */
  writeScript = name: text: writeTextFile {inherit name text; executable = true;};

  /*
   * Writes a text file to /nix/store/<store path>/bin/<name> and
   * marks the file as executable.
   *
   * Example:
   * # Writes my-file to /nix/store/<store path>/bin/my-file and makes executable.
   * writeScriptBin "my-file"
   *   ''
   *   Contents of File
   *   '';
   *
  */
  writeScriptBin = name: text: writeTextFile {inherit name text; executable = true; destination = "/bin/${name}";};

  /*
   * Similar to writeScript. Writes a Shell script and checks its syntax.
   * Automatically includes interpreter above the contents passed.
   *
   * Example:
   * # Writes my-file to /nix/store/<store path> and makes executable.
   * writeShellScript "my-file"
   *   ''
   *   Contents of File
   *   '';
   *
  */
  writeShellScript = name: text:
    writeTextFile {
      inherit name;
      executable = true;
      text = ''
        #!${runtimeShell}
        ${text}
        '';
      checkPhase = ''
        ${stdenv.shell} -n $out
      '';
    };

  /*
   * Similar to writeShellScript and writeScriptBin.
   * Writes an executable Shell script to /nix/store/<store path>/bin/<name> and checks its syntax.
   * Automatically includes interpreter above the contents passed.
   *
   * Example:
   * # Writes my-file to /nix/store/<store path>/bin/my-file and makes executable.
   * writeShellScriptBin "my-file"
   *   ''
   *   Contents of File
   *   '';
   *
  */
  writeShellScriptBin = name : text :
    writeTextFile {
      inherit name;
      executable = true;
      destination = "/bin/${name}";
      text = ''
        #!${runtimeShell}
        ${text}
        '';
      checkPhase = ''
        ${stdenv.shell} -n $out/bin/${name}
      '';
    };

  # Create a C binary
  writeCBin = name: code:
    runCommandCC name
    {
      inherit name code;
      executable = true;
      passAsFile = ["code"];
      # Pointless to do this on a remote machine.
      preferLocalBuild = true;
      allowSubstitutes = false;
    }
    ''
    n=$out/bin/$name
    mkdir -p "$(dirname "$n")"
    mv "$codePath" code.c
    $CC -x c code.c -o "$n"
    '';

  /*
   * Create a forest of symlinks to the files in `paths'.
   *
   * This creates a single derivation that replicates the directory structure
   * of all the input paths.
   *
   * Examples:
   * # adds symlinks of hello to current build.
   * symlinkJoin { name = "myhello"; paths = [ pkgs.hello ]; }
   *
   * # adds symlinks of hello and stack to current build and prints "links added"
   * symlinkJoin { name = "myexample"; paths = [ pkgs.hello pkgs.stack ]; postBuild = "echo links added"; }
   *
   * This creates a derivation with a directory structure like the following:
   *
   * /nix/store/sglsr5g079a5235hy29da3mq3hv8sjmm-myexample
   * |-- bin
   * |   |-- hello -> /nix/store/qy93dp4a3rqyn2mz63fbxjg228hffwyw-hello-2.10/bin/hello
   * |   `-- stack -> /nix/store/6lzdpxshx78281vy056lbk553ijsdr44-stack-2.1.3.1/bin/stack
   * `-- share
   *     |-- bash-completion
   *     |   `-- completions
   *     |       `-- stack -> /nix/store/6lzdpxshx78281vy056lbk553ijsdr44-stack-2.1.3.1/share/bash-completion/completions/stack
   *     |-- fish
   *     |   `-- vendor_completions.d
   *     |       `-- stack.fish -> /nix/store/6lzdpxshx78281vy056lbk553ijsdr44-stack-2.1.3.1/share/fish/vendor_completions.d/stack.fish
   * ...
   *
   * symlinkJoin and linkFarm are similar functions, but they output
   * derivations with different structure.
   *
   * symlinkJoin is used to create a derivation with a familiar directory
   * structure (top-level bin/, share/, etc), but with all actual files being symlinks to
   * the files in the input derivations.
   *
   * symlinkJoin is used many places in nixpkgs to create a single derivation
   * that appears to contain binaries, libraries, documentation, etc from
   * multiple input derivations.
   *
   * linkFarm is instead used to create a simple derivation with symlinks to
   * other derivations.  A derivation created with linkFarm is often used in CI
   * as a easy way to build multiple derivations at once.
   */
  symlinkJoin =
    args_@{ name
         , paths
         , preferLocalBuild ? true
         , allowSubstitutes ? false
         , postBuild ? ""
         , ...
         }:
    let
      args = removeAttrs args_ [ "name" "postBuild" ]
        // {
          inherit preferLocalBuild allowSubstitutes;
          passAsFile = [ "paths" ];
        }; # pass the defaults
    in runCommand name args
      ''
        mkdir -p $out
        for i in $(cat $pathsPath); do
          ${lndir}/bin/lndir -silent $i $out
        done
        ${postBuild}
      '';

  /*
   * Quickly create a set of symlinks to derivations.
   *
   * This creates a simple derivation with symlinks to all inputs.
   *
   * entries is a list of attribute sets like
   * { name = "name" ; path = "/nix/store/..."; }
   *
   * Example:
   *
   * # Symlinks hello and stack paths in store to current $out/hello-test and
   * # $out/foobar.
   * linkFarm "myexample" [ { name = "hello-test"; path = pkgs.hello; } { name = "foobar"; path = pkgs.stack; } ]
   *
   * This creates a derivation with a directory structure like the following:
   *
   * /nix/store/qc5728m4sa344mbks99r3q05mymwm4rw-myexample
   * |-- foobar -> /nix/store/6lzdpxshx78281vy056lbk553ijsdr44-stack-2.1.3.1
   * `-- hello-test -> /nix/store/qy93dp4a3rqyn2mz63fbxjg228hffwyw-hello-2.10
   *
   * See the note on symlinkJoin for the difference between linkFarm and symlinkJoin.
   */
  linkFarm = name: entries: runCommand name { preferLocalBuild = true; allowSubstitutes = false; }
    ''mkdir -p $out
      cd $out
      ${lib.concatMapStrings (x: ''
          mkdir -p "$(dirname ${lib.escapeShellArg x.name})"
          ln -s ${lib.escapeShellArg x.path} ${lib.escapeShellArg x.name}
      '') entries}
    '';

  /*
   * Easily create a linkFarm from a set of derivations.
   *
   * This calls linkFarm with a list of entries created from the list of input
   * derivations.  It turns each input derivation into an attribute set
   * like { name = drv.name ; path = drv }, and passes this to linkFarm.
   *
   * Example:
   *
   * # Symlinks the hello, gcc, and ghc derivations in $out
   * linkFarmFromDrvs "myexample" [ pkgs.hello pkgs.gcc pkgs.ghc ]
   *
   * This creates a derivation with a directory structure like the following:
   *
   * /nix/store/m3s6wkjy9c3wy830201bqsb91nk2yj8c-myexample
   * |-- gcc-wrapper-9.2.0 -> /nix/store/fqhjxf9ii4w4gqcsx59fyw2vvj91486a-gcc-wrapper-9.2.0
   * |-- ghc-8.6.5 -> /nix/store/gnf3s07bglhbbk4y6m76sbh42siym0s6-ghc-8.6.5
   * `-- hello-2.10 -> /nix/store/k0ll91c4npk4lg8lqhx00glg2m735g74-hello-2.10
   */
  linkFarmFromDrvs = name: drvs:
    let mkEntryFromDrv = drv: { name = drv.name; path = drv; };
    in linkFarm name (map mkEntryFromDrv drvs);


  /*
   * Make a package that just contains a setup hook with the given contents.
   * This setup hook will be invoked by any package that includes this package
   * as a buildInput. Optionally takes a list of substitutions that should be
   * applied to the resulting script.
   *
   * Examples:
   * # setup hook that depends on the hello package and runs ./myscript.sh
   * myhellohook = makeSetupHook { deps = [ hello ]; } ./myscript.sh;
   *
   * # wrotes a setup hook where @bash@ myscript.sh is substituted for the
   * # bash interpreter.
   * myhellohookSub = makeSetupHook {
   *                 deps = [ hello ];
   *                 substitutions = { bash = "${pkgs.bash}/bin/bash"; };
   *               } ./myscript.sh;
   */
  makeSetupHook = { name ? "hook", deps ? [], substitutions ? {} }: script:
    runCommand name substitutions
      (''
        mkdir -p $out/nix-support
        cp ${script} $out/nix-support/setup-hook
      '' + lib.optionalString (deps != []) ''
        printWords ${toString deps} > $out/nix-support/propagated-build-inputs
      '' + lib.optionalString (substitutions != {}) ''
        substituteAll ${script} $out/nix-support/setup-hook
      '');


  # Write the references (i.e. the runtime dependencies in the Nix store) of `path' to a file.

  writeReferencesToFile = path: runCommand "runtime-deps"
    {
      exportReferencesGraph = ["graph" path];
    }
    ''
      touch $out
      while read path; do
        echo $path >> $out
        read dummy
        read nrRefs
        for ((i = 0; i < nrRefs; i++)); do read ref; done
      done < graph
    '';


  /* Print an error message if the file with the specified name and
   * hash doesn't exist in the Nix store. This function should only
   * be used by non-redistributable software with an unfree license
   * that we need to require the user to download manually. It produces
   * packages that cannot be built automatically.
   *
   * Examples:
   *
   * requireFile {
   *   name = "my-file";
   *   url = "http://example.com/download/";
   *   sha256 = "ffffffffffffffffffffffffffffffffffffffffffffffffffff";
   * }
   */
  requireFile = { name ? null
                , sha256 ? null
                , sha1 ? null
                , url ? null
                , message ? null
                , hashMode ? "flat"
                } :
    assert (message != null) || (url != null);
    assert (sha256 != null) || (sha1 != null);
    assert (name != null) || (url != null);
    let msg =
      if message != null then message
      else ''
        Unfortunately, we cannot download file ${name_} automatically.
        Please go to ${url} to download it yourself, and add it to the Nix store
        using either
          nix-store --add-fixed ${hashAlgo} ${name_}
        or
          nix-prefetch-url --type ${hashAlgo} file:///path/to/${name_}
      '';
      hashAlgo = if sha256 != null then "sha256" else "sha1";
      hash = if sha256 != null then sha256 else sha1;
      name_ = if name == null then baseNameOf (toString url) else name;
    in
    stdenvNoCC.mkDerivation {
      name = name_;
      outputHashMode = hashMode;
      outputHashAlgo = hashAlgo;
      outputHash = hash;
      preferLocalBuild = true;
      allowSubstitutes = false;
      builder = writeScript "restrict-message" ''
        source ${stdenvNoCC}/setup
        cat <<_EOF_

        ***
        ${msg}
        ***

        _EOF_
        exit 1
      '';
    };


  # Copy a path to the Nix store.
  # Nix automatically copies files to the store before stringifying paths.
  # If you need the store path of a file, ${copyPathToStore <path>} can be
  # shortened to ${<path>}.
  copyPathToStore = builtins.filterSource (p: t: true);


  # Copy a list of paths to the Nix store.
  copyPathsToStore = builtins.map copyPathToStore;

  /* Applies a list of patches to a source directory.
   *
   * Examples:
   *
   * # Patching nixpkgs:
   * applyPatches {
   *   src = pkgs.path;
   *   patches = [
   *     (pkgs.fetchpatch {
   *       url = "https://github.com/NixOS/nixpkgs/commit/1f770d20550a413e508e081ddc08464e9d08ba3d.patch";
   *       sha256 = "1nlzx171y3r3jbk0qhvnl711kmdk57jlq4na8f8bs8wz2pbffymr";
   *     })
   *   ];
   * }
   */
  applyPatches =
    { src
    , name ? (if builtins.typeOf src == "path"
              then builtins.baseNameOf src
              else
                if builtins.isAttrs src && builtins.hasAttr "name" src
                then src.name
                else throw "applyPatches: please supply a `name` argument because a default name can only be computed when the `src` is a path or is an attribute set with a `name` attribute."
             ) + "-patched"
    , patches   ? []
    , postPatch ? ""
    }: stdenvNoCC.mkDerivation {
      inherit name src patches postPatch;
      preferLocalBuild = true;
      allowSubstitutes = false;
      phases = "unpackPhase patchPhase installPhase";
      installPhase = "cp -R ./ $out";
    };
}
