{ lib, config, stdenv, stdenvNoCC, jq, lndir, runtimeShell, shellcheck-minimal }:

let
  inherit (lib)
    optionalAttrs
    warn
    ;
in

rec {

  # Docs in doc/build-helpers/trivial-build-helpers.chapter.md
  # See https://nixos.org/manual/nixpkgs/unstable/#trivial-builder-runCommand
  runCommand = name: env: runCommandWith {
    stdenv = stdenvNoCC;
    runLocal = false;
    inherit name;
    derivationArgs = env;
  };
  # Docs in doc/build-helpers/trivial-build-helpers.chapter.md
  # See https://nixos.org/manual/nixpkgs/unstable/#trivial-builder-runCommandLocal
  runCommandLocal = name: env: runCommandWith {
    stdenv = stdenvNoCC;
    runLocal = true;
    inherit name;
    derivationArgs = env;
  };
  # Docs in doc/build-helpers/trivial-build-helpers.chapter.md
  # See https://nixos.org/manual/nixpkgs/unstable/#trivial-builder-runCommandCC
  runCommandCC = name: env: runCommandWith {
    stdenv = stdenv;
    runLocal = false;
    inherit name;
    derivationArgs = env;
  };
  # `runCommandCCLocal` left out on purpose.
  # We shouldn’t force the user to have a cc in scope.

  # Docs in doc/build-helpers/trivial-build-helpers.chapter.md
  # See https://nixos.org/manual/nixpkgs/unstable/#trivial-builder-runCommandWith
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
    , derivationArgs ? { }
      # name of the resulting derivation
    , name
      # TODO(@Artturin): enable strictDeps always
    }: buildCommand:
      stdenv.mkDerivation ({
        enableParallelBuilding = true;
        inherit buildCommand name;
        passAsFile = [ "buildCommand" ]
          ++ (derivationArgs.passAsFile or [ ]);
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


  # Docs in doc/build-helpers/trivial-build-helpers.chapter.md
  # See https://nixos.org/manual/nixpkgs/unstable/#trivial-builder-writeTextFile
  writeTextFile =
    { name
    , text
    , executable ? false
    , destination ? ""
    , checkPhase ? ""
    , meta ? { }
    , passthru ? { }
    , allowSubstitutes ? false
    , preferLocalBuild ? true
    , derivationArgs ? { }
    }:
    assert lib.assertMsg (destination != "" -> (lib.hasPrefix "/" destination && destination != "/")) ''
      destination must be an absolute path, relative to the derivation's out path,
      got '${destination}' instead.

      Ensure that the path starts with a / and specifies at least the filename.
    '';

    let
      matches = builtins.match "/bin/([^/]+)" destination;
    in
    runCommand name
      ({
        inherit text executable checkPhase allowSubstitutes preferLocalBuild;
        passAsFile = [ "text" ]
          ++ derivationArgs.passAsFile or [ ];
        meta = lib.optionalAttrs (executable && matches != null)
          {
            mainProgram = lib.head matches;
          } // meta // derivationArgs.meta or {};
        passthru = passthru // derivationArgs.passthru or {};
      } // removeAttrs derivationArgs [ "passAsFile" "meta" "passthru" ])
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

  # See doc/build-helpers/trivial-build-helpers.chapter.md
  # or https://nixos.org/manual/nixpkgs/unstable/#trivial-builder-text-writing
  writeText = name: text:
    # TODO: To fully deprecate, replace the assertion with `lib.isString` and remove the warning
    assert lib.assertMsg (lib.strings.isConvertibleWithToString text) ''
      pkgs.writeText ${lib.strings.escapeNixString name}: The second argument should be a string, but it's a ${builtins.typeOf text} instead.'';
    lib.warnIf (! lib.isString text) ''
      pkgs.writeText ${lib.strings.escapeNixString name}: The second argument should be a string, but it's a ${builtins.typeOf text} instead, which is deprecated. Use `toString` to convert the value to a string first.''
    writeTextFile { inherit name text; };

  # See doc/build-helpers/trivial-build-helpers.chapter.md
  # or https://nixos.org/manual/nixpkgs/unstable/#trivial-builder-text-writing
  writeTextDir = path: text: writeTextFile {
    inherit text;
    name = builtins.baseNameOf path;
    destination = "/${path}";
  };

  # See doc/build-helpers/trivial-build-helpers.chapter.md
  # or https://nixos.org/manual/nixpkgs/unstable/#trivial-builder-text-writing
  writeScript = name: text: writeTextFile { inherit name text; executable = true; };

  # See doc/build-helpers/trivial-build-helpers.chapter.md
  # or https://nixos.org/manual/nixpkgs/unstable/#trivial-builder-text-writing
  writeScriptBin = name: text: writeTextFile {
    inherit name text;
    executable = true;
    destination = "/bin/${name}";
  };

  # See doc/build-helpers/trivial-build-helpers.chapter.md
  # or https://nixos.org/manual/nixpkgs/unstable/#trivial-builder-text-writing
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

  # See doc/build-helpers/trivial-build-helpers.chapter.md
  # or https://nixos.org/manual/nixpkgs/unstable/#trivial-builder-text-writing
  writeShellScriptBin = name: text:
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

  # TODO: move parameter documentation to the Nixpkgs manual
  # See doc/build-helpers/trivial-build-helpers.chapter.md
  # or https://nixos.org/manual/nixpkgs/unstable/#trivial-builder-writeShellApplication
  writeShellApplication =
    {
      /*
         The name of the script to write.

         Type: String
       */
      name,
      /*
         The shell script's text, not including a shebang.

         Type: String
       */
      text,
      /*
         Inputs to add to the shell script's `$PATH` at runtime.

         Type: [String|Derivation]
       */
      runtimeInputs ? [ ],
      /*
         Extra environment variables to set at runtime.

         Type: AttrSet
       */
      runtimeEnv ? null,
      /*
         `stdenv.mkDerivation`'s `meta` argument.

         Type: AttrSet
       */
      meta ? { },
      /*
         `stdenv.mkDerivation`'s `passthru` argument.

         Type: AttrSet
       */
      passthru ? { },
      /*
         The `checkPhase` to run. Defaults to `shellcheck` on supported
         platforms and `bash -n`.

         The script path will be given as `$target` in the `checkPhase`.

         Type: String
       */
      checkPhase ? null,
      /*
         Checks to exclude when running `shellcheck`, e.g. `[ "SC2016" ]`.

         See <https://www.shellcheck.net/wiki/> for a list of checks.

         Type: [String]
       */
      excludeShellChecks ? [ ],
      /*
         Extra command-line flags to pass to ShellCheck.

         Type: [String]
       */
      extraShellCheckFlags ? [ ],
      /*
         Bash options to activate with `set -o` at the start of the script.

         Defaults to `[ "errexit" "nounset" "pipefail" ]`.

         Type: [String]
       */
      bashOptions ? [ "errexit" "nounset" "pipefail" ],
      /* Extra arguments to pass to `stdenv.mkDerivation`.

         :::{.caution}
         Certain derivation attributes are used internally,
         overriding those could cause problems.
         :::

         Type: AttrSet
       */
      derivationArgs ? { },
    }:
    writeTextFile {
      inherit name meta passthru derivationArgs;
      executable = true;
      destination = "/bin/${name}";
      allowSubstitutes = true;
      preferLocalBuild = false;
      text = ''
        #!${runtimeShell}
        ${lib.concatMapStringsSep "\n" (option: "set -o ${option}") bashOptions}
      '' + lib.optionalString (runtimeEnv != null)
        (lib.concatStrings
          (lib.mapAttrsToList
            (name: value: ''
              ${lib.toShellVar name value}
              export ${name}
            '')
            runtimeEnv))
      + lib.optionalString (runtimeInputs != [ ]) ''

        export PATH="${lib.makeBinPath runtimeInputs}:$PATH"
      '' + ''

        ${text}
      '';

      checkPhase =
        # GHC (=> shellcheck) isn't supported on some platforms (such as risc-v)
        # but we still want to use writeShellApplication on those platforms
        let
          shellcheckSupported = lib.meta.availableOn stdenv.buildPlatform shellcheck-minimal.compiler && (builtins.tryEval shellcheck-minimal.compiler.outPath).success;
          excludeFlags = lib.optionals (excludeShellChecks != [ ]) [ "--exclude" (lib.concatStringsSep "," excludeShellChecks) ];
          shellcheckCommand = lib.optionalString shellcheckSupported ''
            # use shellcheck which does not include docs
            # pandoc takes long to build and documentation isn't needed for just running the cli
            ${lib.getExe shellcheck-minimal} ${lib.escapeShellArgs (excludeFlags ++ extraShellCheckFlags)} "$target"
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
  # TODO: add to writers? pkgs/build-support/writers
  writeCBin = pname: code:
    runCommandCC pname
      {
        inherit pname code;
        executable = true;
        passAsFile = [ "code" ];
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

  # TODO: deduplicate with documentation in doc/build-helpers/trivial-build-helpers.chapter.md
  #       see also https://github.com/NixOS/nixpkgs/pull/249721
  # See https://nixos.org/manual/nixpkgs/unstable/#trivial-builder-concatText
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
    , passthru ? { }
    }:
    runCommandLocal name
      { inherit files executable checkPhase meta passthru destination; }
      ''
        file=$out$destination
        mkdir -p "$(dirname "$file")"
        cat $files > "$file"

        if [ -n "$executable" ]; then
          chmod +x "$file"
        fi

        eval "$checkPhase"
      '';

  # TODO: deduplicate with documentation in doc/build-helpers/trivial-build-helpers.chapter.md
  #       see also https://github.com/NixOS/nixpkgs/pull/249721
  # See https://nixos.org/manual/nixpkgs/unstable/#trivial-builder-concatText
  /*
    Writes a text file to nix store with no optional parameters available.

    Example:


    # Writes contents of files to /nix/store/<store path>
    concatText "my-file" [ file1 file2 ]


  */
  concatText = name: files: concatTextFile { inherit name files; };

  # TODO: deduplicate with documentation in doc/build-helpers/trivial-build-helpers.chapter.md
  #       see also https://github.com/NixOS/nixpkgs/pull/249721
  # See https://nixos.org/manual/nixpkgs/unstable/#trivial-builder-concatText
  /*
    Writes a text file to nix store with and mark it as executable.

    Example:
    # Writes contents of files to /nix/store/<store path>
    concatScript "my-file" [ file1 file2 ]

  */
  concatScript = name: files: concatTextFile { inherit name files; executable = true; };


  /*
    TODO: Deduplicate this documentation.
    More docs in doc/build-helpers/trivial-build-helpers.chapter.md
    See https://nixos.org/manual/nixpkgs/unstable/#trivial-builder-symlinkJoin

    Create a forest of symlinks to the files in `paths`.

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
    args_@{
      name ?
        assert lib.assertMsg (args_ ? pname && args_ ? version)
          "symlinkJoin requires either a `name` OR `pname` and `version`";
        "${args_.pname}-${args_.version}"
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
    in
    runCommand name args
      ''
        mkdir -p $out
        for i in $(cat $pathsPath); do
          ${lndir}/bin/lndir -silent $i $out
        done
        ${postBuild}
      '';

  # TODO: move linkFarm docs to the Nixpkgs manual
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

      linkCommands = lib.mapAttrsToList
        (name: path: ''
          mkdir -p "$(dirname ${lib.escapeShellArg "${name}"})"
          ln -s ${lib.escapeShellArg "${path}"} ${lib.escapeShellArg "${name}"}
        '')
        entries';
    in
    runCommand name
      {
        preferLocalBuild = true;
        allowSubstitutes = false;
        passthru.entries = entries';
      } ''
      mkdir -p $out
      cd $out
      ${lib.concatStrings linkCommands}
    '';

  # TODO: move linkFarmFromDrvs docs to the Nixpkgs manual
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

  # TODO: move onlyBin docs to the Nixpkgs manual
  /*
    Produce a derivation that links to the target derivation's `/bin`,
    and *only* `/bin`.

    This is useful when your favourite package doesn't have a separate
    bin output and other contents of the package's output (e.g. setup
    hooks) cause trouble when used in your environment.
  */
  onlyBin = drv: runCommand "${drv.name}-only-bin" { } ''
    mkdir -p $out
    ln -s ${lib.getBin drv}/bin $out/bin
  '';


  # Docs in doc/build-helpers/special/makesetuphook.section.md
  # See https://nixos.org/manual/nixpkgs/unstable/#sec-pkgs.makeSetupHook
  makeSetupHook =
    { name ? lib.warn "calling makeSetupHook without passing a name is deprecated." "hook"
      # hooks go in nativeBuildInputs so these will be nativeBuildInputs
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
        inherit propagatedBuildInputs;
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
      '' + lib.optionalString (substitutions != { }) ''
        substituteAll ${script} $out/nix-support/setup-hook
      '');

  # Remove after 25.05 branch-off
  writeReferencesToFile = throw "writeReferencesToFile has been removed. Use writeClosure instead.";

  # Docs in doc/build-helpers/trivial-build-helpers.chapter.md
  # See https://nixos.org/manual/nixpkgs/unstable/#trivial-builder-writeClosure
  writeClosure = paths: runCommand "runtime-deps"
    {
      # Get the cleaner exportReferencesGraph interface
      __structuredAttrs = true;
      exportReferencesGraph.graph = paths;
      nativeBuildInputs = [ jq ];
    }
    ''
      jq -r ".graph | map(.path) | sort | .[]" "$NIX_ATTRS_JSON_FILE" > "$out"
    '';

  # Docs in doc/build-helpers/trivial-build-helpers.chapter.md
  # See https://nixos.org/manual/nixpkgs/unstable/#trivial-builder-writeDirectReferencesToFile
  writeDirectReferencesToFile = path: runCommand "runtime-references"
    {
      exportReferencesGraph = [ "graph" path ];
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

  # TODO: move writeStringReferencesToFile docs to the Nixpkgs manual
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
       from `string` to a second string and wrap that string in a
       derivation. However, that alone is not enough, since nothing in the
       string refers to the output paths of the derivations/paths in its
       context, meaning they'll be considered build-time dependencies and
       removed from the wrapper derivation's closure. Putting the
       necessary output paths in the new string is however not very
       straightforward - the attrset returned by `getContext` contains
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
                [ ])
            packages);
      allPaths = lib.concatStringsSep "\n" (lib.unique (sources ++ namedOutputPaths ++ outputPaths));
      allPathsWithContext = builtins.appendContext allPaths context;
    in
    if builtins ? getContext then
      writeText "string-references" allPathsWithContext
    else
      writeDirectReferencesToFile (writeText "string-file" string);


  # Docs in doc/build-helpers/fetchers.chapter.md
  # See https://nixos.org/manual/nixpkgs/unstable/#requirefile
  requireFile =
    { name ? null
    , sha256 ? null
    , sha1 ? null
    , hash ? null
    , url ? null
    , message ? null
    , hashMode ? "flat"
    }:
      assert (message != null) || (url != null);
      assert (sha256 != null) || (sha1 != null) || (hash != null);
      assert (name != null) || (url != null);
      let
        msg =
          if message != null then message
          else ''
            Unfortunately, we cannot download file ${name_} automatically.
            Please go to ${url} to download it yourself, and add it to the Nix store
            using either
              nix-store --add-fixed ${hashAlgo} ${name_}
            or
              nix-prefetch-url --type ${hashAlgo} file:///path/to/${name_}
          '';
        hashAlgo =
          if hash != null then (builtins.head (lib.strings.splitString "-" hash))
          else if sha256 != null then "sha256"
          else "sha1";
        hashAlgo_ = if hash != null then "" else hashAlgo;
        hash_ =
          if hash != null then hash
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


  # TODO: move copyPathToStore docs to the Nixpkgs manual
  /*
    Copy a path to the Nix store.
    Nix automatically copies files to the store before stringifying paths.
    If you need the store path of a file, ${copyPathToStore <path>} can be
    shortened to ${<path>}.
  */
  copyPathToStore = builtins.filterSource (p: t: true);


  # TODO: move copyPathsToStore docs to the Nixpkgs manual
  /*
    Copy a list of paths to the Nix store.
  */
  copyPathsToStore = builtins.map copyPathToStore;

  # TODO: move applyPatches docs to the Nixpkgs manual
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
    , patches ? [ ]
    , prePatch ? ""
    , postPatch ? ""
    , ...
    }@args:
    if patches == [ ] && prePatch == "" && postPatch == ""
    then src # nothing to do, so use original src to avoid additional drv
    else stdenvNoCC.mkDerivation
      ({
        inherit name src patches prePatch postPatch;
        preferLocalBuild = true;
        allowSubstitutes = false;
        phases = "unpackPhase patchPhase installPhase";
        installPhase = "cp -R ./ $out";
      }
      # Carry `meta` information from the underlying `src` if present.
      // (optionalAttrs (src?meta) { inherit (src) meta; })
      // (removeAttrs args [ "src" "name" "patches" "prePatch" "postPatch" ]));

  # TODO: move docs to Nixpkgs manual
  /* An immutable file in the store with a length of 0 bytes. */
  emptyFile = runCommand "empty-file"
    {
      outputHash = "sha256-d6xi4mKdjkX2JFicDIv5niSzpyI0m/Hnm8GGAIU04kY=";
      outputHashMode = "recursive";
      preferLocalBuild = true;
    } "touch $out";

  # TODO: move docs to Nixpkgs manual
  /* An immutable empty directory in the store. */
  emptyDirectory = runCommand "empty-directory"
    {
      outputHashAlgo = "sha256";
      outputHashMode = "recursive";
      outputHash = "0sjjj9z1dhilhpc8pq4154czrb79z9cm044jvn75kxcjv6v5l2m5";
      preferLocalBuild = true;
    } "mkdir $out";
}
