{ lib, stdenv, stdenvNoCC, lndir }:

let

  runCommand' = stdenv: name: env: buildCommand:
    stdenv.mkDerivation ({
      inherit name buildCommand;
      passAsFile = [ "buildCommand" ];
    } // env);

in

rec {

  # Run the shell command `buildCommand' to produce a store path named
  # `name'.  The attributes in `env' are added to the environment
  # prior to running the command.
  runCommand = runCommandNoCC;
  runCommandNoCC = runCommand' stdenvNoCC;
  runCommandCC = runCommand' stdenv;


  # Create a single file.
  writeTextFile =
    { name # the name of the derivation
    , text
    , executable ? false # run chmod +x ?
    , destination ? ""   # relative path appended to $out eg "/bin/foo"
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

        (test -n "$executable" && chmod +x "$n") || true
      '';


  # Shorthands for `writeTextFile'.
  writeText = name: text: writeTextFile {inherit name text;};
  writeTextDir = name: text: writeTextFile {inherit name text; destination = "/${name}";};
  writeScript = name: text: writeTextFile {inherit name text; executable = true;};
  writeScriptBin = name: text: writeTextFile {inherit name text; executable = true; destination = "/bin/${name}";};


  # Create a forest of symlinks to the files in `paths'.
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


  # Make a package that just contains a setup hook with the given contents.
  makeSetupHook = { deps ? [], substitutions ? {} }: script:
    runCommand "hook" substitutions
      (''
        mkdir -p $out/nix-support
        cp ${script} $out/nix-support/setup-hook
      '' + lib.optionalString (deps != []) ''
        printWords ${toString deps} > $out/nix-support/propagated-native-build-inputs
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


  # Quickly create a set of symlinks to derivations.
  # entries is a list of attribute sets like { name = "name" ; path = "/nix/store/..."; }
  linkFarm = name: entries: runCommand name { preferLocalBuild = true; }
    ("mkdir -p $out; cd $out; \n" +
      (lib.concatMapStrings (x: "ln -s '${x.path}' '${x.name}';\n") entries));


  # Print an error message if the file with the specified name and
  # hash doesn't exist in the Nix store. Do not use this function; it
  # produces packages that cannot be built automatically.
  requireFile = { name ? null
                , sha256 ? null
                , sha1 ? null
                , url ? null
                , message ? null
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
    stdenv.mkDerivation {
      name = name_;
      outputHashAlgo = hashAlgo;
      outputHash = hash;
      preferLocalBuild = true;
      builder = writeScript "restrict-message" ''
        source ${stdenv}/setup
        cat <<_EOF_

        ***
        ${msg}
        ***

        _EOF_
      '';
    };


  # Copy a path to the Nix store.
  # Nix automatically copies files to the store before stringifying paths.
  # If you need the store path of a file, ${copyPathToStore <path>} can be
  # shortened to ${<path>}.
  copyPathToStore = builtins.filterSource (p: t: true);


  # Copy a list of paths to the Nix store.
  copyPathsToStore = builtins.map copyPathToStore;

}
