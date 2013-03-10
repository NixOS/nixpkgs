{ stdenv, lndir }:

rec {

  # Run the shell command `buildCommand' to produce a store path named
  # `name'.  The attributes in `env' are added to the environment
  # prior to running the command.
  runCommand = name: env: buildCommand:
    stdenv.mkDerivation ({
      inherit name buildCommand;
    } // env);


  # Create a single file.
  writeTextFile =
    { name # the name of the derivation
    , text
    , executable ? false # run chmod +x ?
    , destination ? ""   # relative path appended to $out eg "/bin/foo"
    }:
    runCommand name
      { inherit text executable;
        # Pointless to do this on a remote machine.
        preferLocalBuild = true;
      }
      ''
        n=$out${destination}
        mkdir -p "$(dirname "$n")"
        echo -n "$text" > "$n"
        (test -n "$executable" && chmod +x "$n") || true
      '';

    
  # Shorthands for `writeTextFile'.
  writeText = name: text: writeTextFile {inherit name text;};
  writeScript = name: text: writeTextFile {inherit name text; executable = true;};
  writeScriptBin = name: text: writeTextFile {inherit name text; executable = true; destination = "/bin/${name}";};


  # Create a forest of symlinks to the files in `paths'.
  symlinkJoin = name: paths:
    runCommand name { inherit paths; }
      ''
        mkdir -p $out
        for i in $paths; do
          ${lndir}/bin/lndir $i $out
        done
      '';


  # Make a package that just contains a setup hook with the given contents.
  makeSetupHook = { deps ? [], substitutions ? {} }: script:
    runCommand "hook" substitutions
      (''
        mkdir -p $out/nix-support
        cp ${script} $out/nix-support/setup-hook
      '' + stdenv.lib.optionalString (deps != []) ''
        echo ${toString deps} > $out/nix-support/propagated-native-build-inputs
      '' + stdenv.lib.optionalString (substitutions != {}) ''
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
  linkFarm = name: entries: runCommand name {} ("mkdir -p $out; cd $out; \n" +
    (stdenv.lib.concatMapStrings (x: "ln -s '${x.path}' '${x.name}';\n") entries));

  # Require file
  requireFile = {name, sha256, url ? null, message ? null} :
    assert (message != null) || (url != null);
    let msg =
      if message != null then message
      else ''
        Unfortunately, we may not download file ${name} automatically.
        Please, go to ${url}, download it yourself, and add it to the Nix store
        using either
          nix-store --add-fixed sha256 ${name}
        or
          nix-prefetch-url file://path/to/${name}
      '';
    in
    stdenv.mkDerivation {
      inherit name;
      outputHashAlgo = "sha256";
      outputHash = sha256;
      builder = writeScript "restrict-message" ''
source ${stdenv}/setup
cat <<_EOF_

***
${msg}
***

_EOF_
      '';
    };

  # Search in the environment if the same program exists with a set uid or
  # set gid bit.  If it exists, run the first program found, otherwise run
  # the default binary.
  useSetUID = drv: path:
    let
      name = baseNameOf path;
      bin = "${drv}${path}";
    in assert name != "";
      writeScript "setUID-${name}" ''
        #!${stdenv.shell}
        inode=$(stat -Lc %i ${bin})
        for file in $(type -ap ${name}); do
          case $(stat -Lc %a $file) in
            ([2-7][0-7][0-7][0-7])
              if test -r "$file".real; then
                orig=$(cat "$file".real)
                if test $inode = $(stat -Lc %i "$orig"); then
                  exec "$file" "$@"
                fi
              fi;;
          esac
        done
        exec ${bin} "$@"
      '';

}
