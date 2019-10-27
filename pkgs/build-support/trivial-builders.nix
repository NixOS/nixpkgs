{ lib, stdenv, stdenvNoCC, lndir, runtimeShell }:

let

  runCommand' = stdenv: name: env: buildCommand:
    stdenv.mkDerivation ({
      inherit name buildCommand;
      passAsFile = [ "buildCommand" ];
    } // env);

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
  */
  runCommand = runCommandNoCC;
  runCommandNoCC = runCommand' stdenvNoCC;
  runCommandCC = runCommand' stdenv;


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
  * Examples:
  * # adds symlinks of hello to current build.
  * { symlinkJoin, hello }:
  * symlinkJoin { name = "myhello"; paths = [ hello ]; }
  *
  * # adds symlinks of hello to current build and prints "links added"
  * { symlinkJoin, hello }:
  * symlinkJoin { name = "myhello"; paths = [ hello ]; postBuild = "echo links added"; }
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
        // { inherit preferLocalBuild allowSubstitutes; }; # pass the defaults
    in runCommand name args
      ''
        mkdir -p $out
        for i in $paths; do
          ${lndir}/bin/lndir -silent $i $out
        done
        ${postBuild}
      '';


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


  /*
   * Quickly create a set of symlinks to derivations.
   * entries is a list of attribute sets like
   * { name = "name" ; path = "/nix/store/..."; }
   *
   * Example:
   *
   * # Symlinks hello path in store to current $out/hello
   * linkFarm "hello" [ { name = "hello"; path = pkgs.hello; } ];
   *
   */
  linkFarm = name: entries: runCommand name { preferLocalBuild = true; allowSubstitutes = false; }
    ''mkdir -p $out
      cd $out
      ${lib.concatMapStrings (x: ''
          mkdir -p "$(dirname ${lib.escapeShellArg x.name})"
          ln -s ${lib.escapeShellArg x.path} ${lib.escapeShellArg x.name}
      '') entries}
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
