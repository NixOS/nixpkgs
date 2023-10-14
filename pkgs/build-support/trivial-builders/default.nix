{ lib, stdenv, stdenvNoCC, lndir, runtimeShell, shellcheck, haskell }:

let
  inherit (lib)
    optionalAttrs
    warn
    ;
in

rec {

  /* Run the shell command `buildCommand' to produce a store path named
   `name'.  The attributes in `env' are added to the environment
   prior to running the command. By default `runCommand` runs in a
   stdenv with no compiler environment. `runCommandCC` uses the default
   stdenv, `pkgs.stdenv`.

   Example:


   runCommand "name" {envVariable = true;} ''echo hello > $out''
   runCommandCC "name" {} ''gcc -o myfile myfile.c; cp myfile $out'';


   The `*Local` variants force a derivation to be built locally,
   it is not substituted.

   This is intended for very cheap commands (<1s execution time).
   It saves on the network roundrip and can speed up a build.

   It is the same as adding the special fields

   `preferLocalBuild = true;`
   `allowSubstitutes = false;`

   to a derivation’s attributes.
  */
  runCommand = name: env: runCommandWith {
    stdenv = stdenvNoCC;
    runLocal = false;
    inherit name;
    derivationArgs = env;
  };
  runCommandLocal = name: env: runCommandWith {
    stdenv = stdenvNoCC;
    runLocal = true;
    inherit name;
    derivationArgs = env;
  };

  runCommandCC = name: env: runCommandWith {
    stdenv = stdenv;
    runLocal = false;
    inherit name;
    derivationArgs = env;
  };
  # `runCommandCCLocal` left out on purpose.
  # We shouldn’t force the user to have a cc in scope.

  /* Generalized version of the `runCommand`-variants
    which does customized behavior via a single
    attribute set passed as the first argument
    instead of having a lot of variants like
    `runCommand*`. Additionally it allows changing
    the used `stdenv` freely and has a more explicit
    approach to changing the arguments passed to
    `stdenv.mkDerivation`.
   */
  runCommandWith =
    let
      # prevent infinite recursion for the default stdenv value
      defaultStdenv = stdenv;
    in
    {
    # which stdenv to use, defaults to a stdenv with a C compiler, pkgs.stdenv
      stdenv ? defaultStdenv
    # whether to build this derivation locally instead of substituting
    , runLocal ? false
    # extra arguments to pass to stdenv.mkDerivation
    , derivationArgs ? {}
    # name of the resulting derivation
    , name
    # TODO(@Artturin): enable strictDeps always
    }: buildCommand:
    stdenv.mkDerivation ({
      enableParallelBuilding = true;
      inherit buildCommand name;
      passAsFile = [ "buildCommand" ]
        ++ (derivationArgs.passAsFile or []);
    }
    // lib.optionalAttrs (! derivationArgs?meta) {
      pos = let args = builtins.attrNames derivationArgs; in
        if builtins.length args > 0
        then builtins.unsafeGetAttrPos (builtins.head args) derivationArgs
        else null;
    }
    // (lib.optionalAttrs runLocal {
          preferLocalBuild = true;
          allowSubstitutes = false;
       })
    // builtins.removeAttrs derivationArgs [ "passAsFile" ]);


  /* Writes a text file to the nix store.
    The contents of text is added to the file in the store.

    Example:


    # Writes my-file to /nix/store/<store path>
    writeTextFile {
      name = "my-file";
      text = ''
        Contents of File
      '';
    }


    See also the `writeText` helper function below.


    # Writes executable my-file to /nix/store/<store path>/bin/my-file
    writeTextFile {
      name = "my-file";
      text = ''
        Contents of File
      '';
      executable = true;
      destination = "/bin/my-file";
    }


   */
  writeTextFile =
    { name # the name of the derivation
    , text
    , executable ? false # run chmod +x ?
    , destination ? ""   # relative path appended to $out eg "/bin/foo"
    , checkPhase ? ""    # syntax checks, e.g. for scripts
    , meta ? { }
    , allowSubstitutes ? false
    , preferLocalBuild ? true
    }:
    let
      matches = builtins.match "/bin/([^/]+)" destination;
    in
    runCommand name
      { inherit text executable checkPhase allowSubstitutes preferLocalBuild;
        passAsFile = [ "text" ];
        meta = lib.optionalAttrs (executable && matches != null) {
          mainProgram = lib.head matches;
        } // meta;
      }
      ''
        target=$out${lib.escapeShellArg destination}
        mkdir -p "$(dirname "$target")"

        if [ -e "$textPath" ]; then
          mv "$textPath" "$target"
        else
          echo -n "$text" > "$target"
        fi

        if [ -n "$executable" ]; then
          chmod +x "$target"
        fi

        eval "$checkPhase"
      '';

  /*
   Writes a text file to nix store with no optional parameters available.

   Example:


   # Writes contents of file to /nix/store/<store path>
   writeText "my-file"
     ''
     Contents of File
     '';


  */
  writeText = name: text: writeTextFile {inherit name text;};

  /*
    Writes a text file to nix store in a specific directory with no
    optional parameters available.

    Example:


    # Writes contents of file to /nix/store/<store path>/share/my-file
    writeTextDir "share/my-file"
     ''
     Contents of File
     '';


  */
  writeTextDir = path: text: writeTextFile {
    inherit text;
    name = builtins.baseNameOf path;
    destination = "/${path}";
  };

  /*
    Writes a text file to /nix/store/<store path> and marks the file as
    executable.

    If passed as a build input, will be used as a setup hook. This makes setup
    hooks more efficient to create: you don't need a derivation that copies
    them to $out/nix-support/setup-hook, instead you can use the file as is.

    Example:


    # Writes my-file to /nix/store/<store path> and makes executable
    writeScript "my-file"
      ''
      Contents of File
      '';


  */
  writeScript = name: text: writeTextFile {inherit name text; executable = true;};

  /*
    Writes a text file to /nix/store/<store path>/bin/<name> and
    marks the file as executable.

    Example:



    # Writes my-file to /nix/store/<store path>/bin/my-file and makes executable.
    writeScriptBin "my-file"
      ''
      Contents of File
      '';


  */
  writeScriptBin = name: text: writeTextFile {
    inherit name text;
    executable = true;
    destination = "/bin/${name}";
  };

  /*
    Similar to writeScript. Writes a Shell script and checks its syntax.
    Automatically includes interpreter above the contents passed.

    Example:


    # Writes my-file to /nix/store/<store path> and makes executable.
    writeShellScript "my-file"
      ''
      Contents of File
      '';


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
        ${stdenv.shellDryRun} "$target"
      '';
    };

  /*
    Similar to writeShellScript and writeScriptBin.
    Writes an executable Shell script to /nix/store/<store path>/bin/<name> and checks its syntax.
    Automatically includes interpreter above the contents passed.

    Example:


    # Writes my-file to /nix/store/<store path>/bin/my-file and makes executable.
    writeShellScriptBin "my-file"
      ''
      Contents of File
      '';


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
        ${stdenv.shellDryRun} "$target"
      '';
      meta.mainProgram = name;
    };

  /*
    Similar to writeShellScriptBin and writeScriptBin.
    Writes an executable Shell script to /nix/store/<store path>/bin/<name> and
    checks its syntax with shellcheck and the shell's -n option.
    Automatically includes sane set of shellopts (errexit, nounset, pipefail)
    and handles creation of PATH based on runtimeInputs

    Note that the checkPhase uses stdenv.shell for the test run of the script,
    while the generated shebang uses runtimeShell. If, for whatever reason,
    those were to mismatch you might lose fidelity in the default checks.

    Example:

    Writes my-file to /nix/store/<store path>/bin/my-file and makes executable.


    writeShellApplication {
      name = "my-file";
      runtimeInputs = [ curl w3m ];
      text = ''
        curl -s 'https://nixos.org' | w3m -dump -T text/html
       '';
    }

  */
  writeShellApplication =
    { name
    , text
    , runtimeInputs ? [ ]
    , meta ? { }
    , checkPhase ? null
    }:
    writeTextFile {
      inherit name meta;
      executable = true;
      destination = "/bin/${name}";
      allowSubstitutes = true;
      preferLocalBuild = false;
      text = ''
        #!${runtimeShell}
        set -o errexit
        set -o nounset
        set -o pipefail
      '' + lib.optionalString (runtimeInputs != [ ]) ''

        export PATH="${lib.makeBinPath runtimeInputs}:$PATH"
      '' + ''

        ${text}
      '';

      checkPhase =
        # GHC (=> shellcheck) isn't supported on some platforms (such as risc-v)
        # but we still want to use writeShellApplication on those platforms
        let
          shellcheckSupported = lib.meta.availableOn stdenv.buildPlatform shellcheck.compiler;
          shellcheckCommand = lib.optionalString shellcheckSupported ''
            # use shellcheck which does not include docs
            # pandoc takes long to build and documentation isn't needed for just running the cli
            ${lib.getExe (haskell.lib.compose.justStaticExecutables shellcheck.unwrapped)} "$target"
          '';
        in
        if checkPhase == null then ''
          runHook preCheck
          ${stdenv.shellDryRun} "$target"
          ${shellcheckCommand}
          runHook postCheck
        ''
        else checkPhase;
    };

  # Create a C binary
  writeCBin = pname: code:
    runCommandCC pname
    {
      inherit pname code;
      executable = true;
      passAsFile = ["code"];
      # Pointless to do this on a remote machine.
      preferLocalBuild = true;
      allowSubstitutes = false;
      meta = {
        mainProgram = pname;
      };
    }
    ''
      n=$out/bin/${pname}
      mkdir -p "$(dirname "$n")"
      mv "$codePath" code.c
      $CC -x c code.c -o "$n"
    '';


  /* concat a list of files to the nix store.
    The contents of files are added to the file in the store.

    Example:


    # Writes my-file to /nix/store/<store path>
    concatTextFile {
      name = "my-file";
      files = [ drv1 "${drv2}/path/to/file" ];
    }


    See also the `concatText` helper function below.


    # Writes executable my-file to /nix/store/<store path>/bin/my-file
    concatTextFile {
      name = "my-file";
      files = [ drv1 "${drv2}/path/to/file" ];
      executable = true;
      destination = "/bin/my-file";
    }


   */
  concatTextFile =
    { name # the name of the derivation
    , files
    , executable ? false # run chmod +x ?
    , destination ? ""   # relative path appended to $out eg "/bin/foo"
    , checkPhase ? ""    # syntax checks, e.g. for scripts
    , meta ? { }
    }:
    runCommandLocal name
      { inherit files executable checkPhase meta destination; }
      ''
        file=$out$destination
        mkdir -p "$(dirname "$file")"
        cat $files > "$file"

        if [ -n "$executable" ]; then
          chmod +x "$file"
        fi

        eval "$checkPhase"
      '';


  /*
    Writes a text file to nix store with no optional parameters available.

    Example:


    # Writes contents of files to /nix/store/<store path>
    concatText "my-file" [ file1 file2 ]


  */
  concatText = name: files: concatTextFile { inherit name files; };

  /*
    Writes a text file to nix store with and mark it as executable.

    Example:
    # Writes contents of files to /nix/store/<store path>
    concatScript "my-file" [ file1 file2 ]

  */
  concatScript = name: files: concatTextFile { inherit name files; executable = true; };


  /*
    Create a forest of symlinks to the files in `paths'.

    This creates a single derivation that replicates the directory structure
    of all the input paths.

    BEWARE: it may not "work right" when the passed paths contain symlinks to directories.

    Example:


    # adds symlinks of hello to current build.
    symlinkJoin { name = "myhello"; paths = [ pkgs.hello ]; }




    # adds symlinks of hello and stack to current build and prints "links added"
    symlinkJoin { name = "myexample"; paths = [ pkgs.hello pkgs.stack ]; postBuild = "echo links added"; }


    This creates a derivation with a directory structure like the following:


    /nix/store/sglsr5g079a5235hy29da3mq3hv8sjmm-myexample
    |-- bin
    |   |-- hello -> /nix/store/qy93dp4a3rqyn2mz63fbxjg228hffwyw-hello-2.10/bin/hello
    |   `-- stack -> /nix/store/6lzdpxshx78281vy056lbk553ijsdr44-stack-2.1.3.1/bin/stack
    `-- share
        |-- bash-completion
        |   `-- completions
        |       `-- stack -> /nix/store/6lzdpxshx78281vy056lbk553ijsdr44-stack-2.1.3.1/share/bash-completion/completions/stack
        |-- fish
        |   `-- vendor_completions.d
        |       `-- stack.fish -> /nix/store/6lzdpxshx78281vy056lbk553ijsdr44-stack-2.1.3.1/share/fish/vendor_completions.d/stack.fish
    ...


    symlinkJoin and linkFarm are similar functions, but they output
    derivations with different structure.

    symlinkJoin is used to create a derivation with a familiar directory
    structure (top-level bin/, share/, etc), but with all actual files being symlinks to
    the files in the input derivations.

    symlinkJoin is used many places in nixpkgs to create a single derivation
    that appears to contain binaries, libraries, documentation, etc from
    multiple input derivations.

    linkFarm is instead used to create a simple derivation with symlinks to
    other derivations.  A derivation created with linkFarm is often used in CI
    as a easy way to build multiple derivations at once.
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
    Quickly create a set of symlinks to derivations.

    This creates a simple derivation with symlinks to all inputs.

    entries can be a list of attribute sets like

    [ { name = "name" ; path = "/nix/store/..."; } ]


    or an attribute set name -> path like:

    { name = "/nix/store/..."; other = "/nix/store/..."; }


    Example:

    # Symlinks hello and stack paths in store to current $out/hello-test and
    # $out/foobar.
    linkFarm "myexample" [ { name = "hello-test"; path = pkgs.hello; } { name = "foobar"; path = pkgs.stack; } ]

    This creates a derivation with a directory structure like the following:

    /nix/store/qc5728m4sa344mbks99r3q05mymwm4rw-myexample
    |-- foobar -> /nix/store/6lzdpxshx78281vy056lbk553ijsdr44-stack-2.1.3.1
    `-- hello-test -> /nix/store/qy93dp4a3rqyn2mz63fbxjg228hffwyw-hello-2.10


    See the note on symlinkJoin for the difference between linkFarm and symlinkJoin.
   */
  linkFarm = name: entries:
  let
    entries' =
      if (lib.isAttrs entries) then entries
      # We do this foldl to have last-wins semantics in case of repeated entries
      else if (lib.isList entries) then lib.foldl (a: b: a // { "${b.name}" = b.path; }) { } entries
      else throw "linkFarm entries must be either attrs or a list!";

    linkCommands = lib.mapAttrsToList (name: path: ''
      mkdir -p "$(dirname ${lib.escapeShellArg "${name}"})"
      ln -s ${lib.escapeShellArg "${path}"} ${lib.escapeShellArg "${name}"}
    '') entries';
  in
  runCommand name {
    preferLocalBuild = true;
    allowSubstitutes = false;
    passthru.entries = entries';
   } ''
    mkdir -p $out
    cd $out
    ${lib.concatStrings linkCommands}
  '';

  /*
    Easily create a linkFarm from a set of derivations.

    This calls linkFarm with a list of entries created from the list of input
    derivations.  It turns each input derivation into an attribute set
    like { name = drv.name ; path = drv }, and passes this to linkFarm.

    Example:

    # Symlinks the hello, gcc, and ghc derivations in $out
    linkFarmFromDrvs "myexample" [ pkgs.hello pkgs.gcc pkgs.ghc ]

    This creates a derivation with a directory structure like the following:


    /nix/store/m3s6wkjy9c3wy830201bqsb91nk2yj8c-myexample
    |-- gcc-wrapper-9.2.0 -> /nix/store/fqhjxf9ii4w4gqcsx59fyw2vvj91486a-gcc-wrapper-9.2.0
    |-- ghc-8.6.5 -> /nix/store/gnf3s07bglhbbk4y6m76sbh42siym0s6-ghc-8.6.5
    `-- hello-2.10 -> /nix/store/k0ll91c4npk4lg8lqhx00glg2m735g74-hello-2.10

  */
  linkFarmFromDrvs = name: drvs:
    let mkEntryFromDrv = drv: { name = drv.name; path = drv; };
    in linkFarm name (map mkEntryFromDrv drvs);


  # docs in doc/builders/special/makesetuphook.section.md
  makeSetupHook =
    { name ? lib.warn "calling makeSetupHook without passing a name is deprecated." "hook"
    , deps ? [ ]
      # hooks go in nativeBuildInput so these will be nativeBuildInput
    , propagatedBuildInputs ? [ ]
      # these will be buildInputs
    , depsTargetTargetPropagated ? [ ]
    , meta ? { }
    , passthru ? { }
    , substitutions ? { }
    }:
    script:
    runCommand name
      (substitutions // {
        # TODO(@Artturin:) substitutions should be inside the env attrset
        # but users are likely passing non-substitution arguments through substitutions
        # turn off __structuredAttrs to unbreak substituteAll
        __structuredAttrs = false;
        inherit meta;
        inherit depsTargetTargetPropagated;
        propagatedBuildInputs =
          # remove list conditionals before 23.11
          lib.warnIf (!lib.isList deps) "'deps' argument to makeSetupHook must be a list. content of deps: ${toString deps}"
            (lib.warnIf (deps != [ ]) "'deps' argument to makeSetupHook is deprecated and will be removed in release 23.11., Please use propagatedBuildInputs instead. content of deps: ${toString deps}"
              propagatedBuildInputs ++ (if lib.isList deps then deps else [ deps ]));
        strictDeps = true;
        # TODO 2023-01, no backport: simplify to inherit passthru;
        passthru = passthru
          // optionalAttrs (substitutions?passthru)
            (warn "makeSetupHook (name = ${lib.strings.escapeNixString name}): `substitutions.passthru` is deprecated. Please set `passthru` directly."
              substitutions.passthru);
      })
      (''
        mkdir -p $out/nix-support
        cp ${script} $out/nix-support/setup-hook
        recordPropagatedDependencies
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
    Write the set of references to a file, that is, their immediate dependencies.

    This produces the equivalent of `nix-store -q --references`.
   */
  writeDirectReferencesToFile = path: runCommand "runtime-references"
    {
      exportReferencesGraph = ["graph" path];
      inherit path;
    }
    ''
      touch ./references
      while read p; do
        read dummy
        read nrRefs
        if [[ $p == $path ]]; then
          for ((i = 0; i < nrRefs; i++)); do
            read ref;
            echo $ref >>./references
          done
        else
          for ((i = 0; i < nrRefs; i++)); do
            read ref;
          done
        fi
      done < graph
      sort ./references >$out
    '';


  /*
    Extract a string's references to derivations and paths (its
    context) and write them to a text file, removing the input string
    itself from the dependency graph. This is useful when you want to
    make a derivation depend on the string's references, but not its
    contents (to avoid unnecessary rebuilds, for example).

    Note that this only works as intended on Nix >= 2.3.
   */
  writeStringReferencesToFile = string:
    /*
     The basic operation this performs is to copy the string context
     from `string' to a second string and wrap that string in a
     derivation. However, that alone is not enough, since nothing in the
     string refers to the output paths of the derivations/paths in its
     context, meaning they'll be considered build-time dependencies and
     removed from the wrapper derivation's closure. Putting the
     necessary output paths in the new string is however not very
     straightforward - the attrset returned by `getContext' contains
     only references to derivations' .drv-paths, not their output
     paths. In order to "convert" them, we try to extract the
     corresponding paths from the original string using regex.
    */
    let
      # Taken from https://github.com/NixOS/nix/blob/130284b8508dad3c70e8160b15f3d62042fc730a/src/libutil/hash.cc#L84
      nixHashChars = "0123456789abcdfghijklmnpqrsvwxyz";
      context = builtins.getContext string;
      derivations = lib.filterAttrs (n: v: v ? outputs) context;
      # Objects copied from outside of the store, such as paths and
      # `builtins.fetch*`ed ones
      sources = lib.attrNames (lib.filterAttrs (n: v: v ? path) context);
      packages =
        lib.mapAttrs'
          (name: value:
            {
              inherit value;
              name = lib.head (builtins.match "${builtins.storeDir}/[${nixHashChars}]+-(.*)\.drv" name);
            })
          derivations;
      # The syntax of output paths differs between outputs named `out`
      # and other, explicitly named ones. For explicitly named ones,
      # the output name is suffixed as `-name`, but `out` outputs
      # aren't suffixed at all, and thus aren't easily distinguished
      # from named output paths. Therefore, we find all the named ones
      # first so we can use them to remove false matches when looking
      # for `out` outputs (see the definition of `outputPaths`).
      namedOutputPaths =
        lib.flatten
          (lib.mapAttrsToList
            (name: value:
              (map
                (output:
                  lib.filter
                    lib.isList
                    (builtins.split "(${builtins.storeDir}/[${nixHashChars}]+-${name}-${output})" string))
                (lib.remove "out" value.outputs)))
            packages);
      # Only `out` outputs
      outputPaths =
        lib.flatten
          (lib.mapAttrsToList
            (name: value:
              if lib.elem "out" value.outputs then
                lib.filter
                  (x: lib.isList x &&
                      # If the matched path is in `namedOutputPaths`,
                      # it's a partial match of an output path where
                      # the output name isn't `out`
                      lib.all (o: !lib.hasPrefix (lib.head x) o) namedOutputPaths)
                  (builtins.split "(${builtins.storeDir}/[${nixHashChars}]+-${name})" string)
              else
                [])
            packages);
      allPaths = lib.concatStringsSep "\n" (lib.unique (sources ++ namedOutputPaths ++ outputPaths));
      allPathsWithContext = builtins.appendContext allPaths context;
    in
      if builtins ? getContext then
        writeText "string-references" allPathsWithContext
      else
        writeDirectReferencesToFile (writeText "string-file" string);


  /* Print an error message if the file with the specified name and
    hash doesn't exist in the Nix store. This function should only
    be used by non-redistributable software with an unfree license
    that we need to require the user to download manually. It produces
    packages that cannot be built automatically.

    Example:

    requireFile {
      name = "my-file";
      url = "http://example.com/download/";
      sha256 = "ffffffffffffffffffffffffffffffffffffffffffffffffffff";
    }

   */
  requireFile = { name ? null
                , sha256 ? null
                , sha1 ? null
                , hash ? null
                , url ? null
                , message ? null
                , hashMode ? "flat"
                } :
    assert (message != null) || (url != null);
    assert (sha256 != null) || (sha1 != null) || (hash != null);
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
      hashAlgo = if hash != null then (builtins.head (lib.strings.splitString "-" hash))
            else if sha256 != null then "sha256"
            else "sha1";
      hashAlgo_ = if hash != null then "" else hashAlgo;
      hash_ = if hash != null then hash
         else if sha256 != null then sha256
         else sha1;
      name_ = if name == null then baseNameOf (toString url) else name;
    in
    stdenvNoCC.mkDerivation {
      name = name_;
      outputHashMode = hashMode;
      outputHashAlgo = hashAlgo_;
      outputHash = hash_;
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


  /*
    Copy a path to the Nix store.
    Nix automatically copies files to the store before stringifying paths.
    If you need the store path of a file, ${copyPathToStore <path>} can be
    shortened to ${<path>}.
  */
  copyPathToStore = builtins.filterSource (p: t: true);


  /*
    Copy a list of paths to the Nix store.
  */
  copyPathsToStore = builtins.map copyPathToStore;

  /* Applies a list of patches to a source directory.

    Example:

    # Patching nixpkgs:

    applyPatches {
      src = pkgs.path;
      patches = [
        (pkgs.fetchpatch {
          url = "https://github.com/NixOS/nixpkgs/commit/1f770d20550a413e508e081ddc08464e9d08ba3d.patch";
          sha256 = "1nlzx171y3r3jbk0qhvnl711kmdk57jlq4na8f8bs8wz2pbffymr";
        })
      ];
    }

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
    , ...
    }@args: stdenvNoCC.mkDerivation {
      inherit name src patches postPatch;
      preferLocalBuild = true;
      allowSubstitutes = false;
      phases = "unpackPhase patchPhase installPhase";
      installPhase = "cp -R ./ $out";
    }
    # Carry `meta` information from the underlying `src` if present.
    // (optionalAttrs (src?meta) { inherit (src) meta; })
    // (removeAttrs args [ "src" "name" "patches" "postPatch" ]);

  /* An immutable file in the store with a length of 0 bytes. */
  emptyFile = runCommand "empty-file" {
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "0ip26j2h11n1kgkz36rl4akv694yz65hr72q4kv4b3lxcbi65b3p";
    preferLocalBuild = true;
  } "touch $out";

  /* An immutable empty directory in the store. */
  emptyDirectory = runCommand "empty-directory" {
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "0sjjj9z1dhilhpc8pq4154czrb79z9cm044jvn75kxcjv6v5l2m5";
    preferLocalBuild = true;
  } "mkdir $out";
}
