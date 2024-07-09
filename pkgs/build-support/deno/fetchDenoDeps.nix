{
  stdenvNoCC,
  deno,
  jq,
  gnused,
  coreutils,
}@topLevelArgs:
{
  # Use this deno binary
  deno ? topLevelArgs.deno,

  # Hash of the vendored dependencies. Leave empty if you dont know it yet
  outputHash,

  # Configuration for finding the main script and the config file 
  # The main script. Used with `deno cache` to fetch dependencies.
  script,
  # The deno.json config file. Leave unset to use denos default behavior (search for deno.json and deno.jsonc next to the script)
  denoJson ? null,
  # Customize the deno lockfile location.  Leave unset to use denos default behavior (search for deno.lock next to the script)
  denoLock ? null,
  ...
}@args:
stdenvNoCC.mkDerivation (
  finalAttrs:
  (
    args
    // {
      denoJsonFlag = if denoJson then "-c ${denoJson}" else "";
      denoLockFlag = if denoLock then "-c ${denoLock}" else "";
      nativeBuildInputs = [
        deno
        jq
        gnused
        coreutils
      ];

      # run the same build as our main derivation to ensure we capture the correct set of dependencies
      buildPhase = ''
        ERROR_OCCURRED=false

        export DENO_DIR="$(mktemp -d)"
        export DENO_NO_UPDATE_CHECK=true
        export DENO_NO_PACKAGE_JSON=true
        export DENO_JOBS=1

        if test -z '${script}' ; then
          echo "error: You need to specify a script. It is probably something like 'main.ts'"
          echo "fix: Adjust you nix code to pass a main file."
          exit 1
        fi

        if ! test -f '${script}' ; then
          echo "error: The script '${script}' for your application does not exist."
          echo "fix: Run 'echo \"console.log(\\\"Hello world!\\\")\" > ${script}' to create it."
          ERROR_OCCURRED=true
        fi

        if ! test -f "${denoJson}" ; then
          if test "${denoJson}" = "deno.json" ; then
            echo "error: There is no deno config file in your project. For now we need every project to have a config file."
            echo "fix: Run 'deno init' to create it."
          else
            echo "error: The deno config file at '${denoJson}' you specified does not exist."
            echo "fix: Create '${denoJson}'."
          fi
          ERROR_OCCURRED=true
        fi

        LOCKFILE="$((jq -r '.lock' '${denoJson}' || true) | sed -E 's/^(null)?$/deno.lock/')"
        if test -z "$LOCKFILE" ; then
          LOCKFILE="deno.lock"
        fi
        mkdir node_modules
        mkdir vendor
        mkdir deno

        if ! test -f "$LOCKFILE" ; then
          echo "error: Your lockfile '$LOCKFILE' does not seem to exist."
          echo "fix: Run 'deno run --reload ${script}' to create it."
          ERROR_OCCURRED=true
        fi

        if test "$ERROR_OCCURRED" = "true" ; then
          exit 1
        fi

        export LOCKFILE_HASH=$(sha256sum "$LOCKFILE" | cut -d' ' -f1)

        # This fun dance, makes the cache command run twice, because the DENO_DIR is not reproducible otherwise
        deno cache ${finalAttrs.denoJsonFlag} --lock deno.lock --vendor=true --node-modules-dir=true ${script}
        rm -rf deno
        mkdir deno
        deno cache -c ${denoJson} --lock deno.lock --vendor=true --node-modules-dir=true ${script}

        # These two files are not always reproducible and also not required
        rm node_modules/.deno/.deno.lock.poll
        rm node_modules/.deno/.deno.lock

        # This one is different on every build. There is a open PR to fix this
        # https://github.com/denoland/deno/issues/24479
        # rm node_modules/.deno/.setup-cache.bin

        # Make the symlinks in node_modules relative
        for link in $(find node_modules -type l | sort) ; do
          ln --force --symbolic --no-dereference --relative "$(readlink --canonicalize "$link")" "$link"
        done

        # Filter the files in DENO_DIR that we actually need
        OLD_DENO_DIR="$DENO_DIR"
        export DENO_DIR="$(mktemp -d)"
        # We do this weird dance with jq to make sure the content of the files is sorted, because by default they are not. 
        for file in $(find $OLD_DENO_DIR/npm -type f -name 'registry.json' | sed "s|^$OLD_DENO_DIR||g" | sort) ; do
          target_file="$DENO_DIR/$file"
          mkdir -p "$(dirname "$target_file")"
          # There should only be registry.json files here
          # echo '###############################################################################'
          echo $file
          # cat $file

          jq -Sc '.' "$OLD_DENO_DIR/$file" > "$target_file"
          # jq -S '.versions = ( .versions | with_entries( select(.key == ("5.1.0", "other")) ) )'
        done


        LOCKFILE_HASH_AFTER=$(sha256sum "$LOCKFILE" | cut -d' ' -f1)

        if test "$LOCKFILE_HASH" != "$LOCKFILE_HASH_AFTER" ; then
          echo "error: Your lockfile changed while running 'deno cache ${script}'. We cant do reproducible builds this way. You probably have unlocked imports somewhere in your code. To fix this run 'deno cache ${script}' and commit the changed lockfile." >&2
          echo "fix: Run 'deno cache ${script}' and commit the changed lockfile." >&2
          ERROR_OCCURRED=true
        fi

        if test -f vendor/manifest.json ; then
          for import in $(cat vendor/manifest.json | jq -r '.modules | keys[]') ; do
            warning="$(cat vendor/manifest.json | jq -r '.modules["'"$import"'"].headers["x-deno-warning"]' || true)"
            echo "error: Import of '$import' produced a warning. This usually means, that your import is not locked. While this does not always affect reproducibility, it significantly increases the chance of weird errors if we allowed this. You don't like weird bugs, do you? For this reason I am now aborting your build and forcing you to fix it." >&2
            echo "reference: $warning" >&2
            echo "fix: Add the import to your '"'${denoJson}'"' file and lock it by running 'deno add \"$import\"'" >&2
            ERROR_OCCURRED=true
          done
        fi

        if test "$ERROR_OCCURRED" = "true" ; then
          exit 1
        fi
      '';

      installPhase = ''
        mkdir -p $out

        # Place vendored https modules in out
        mv vendor $out

        # Place node_modules in out
        mv node_modules $out/node_modules

        # Place lockfile hash in out
        echo "$LOCKFILE_HASH" | cut -d' ' -f1 > $out/lockfile.hash

        # Place the deno version in out
        echo "${deno.version}" > $out/deno.version

        # Place the denodir in out 
        mv $DENO_DIR $out/deno_dir
      '';

      # specify the content hash of this derivations output
      outputHashMode = "nar";
    }
    // (
      if outputHash != "" then
        { outputHash = outputHash; }
      else
        {
          outputHash = "";
          outputHashAlgo = "sha256";
        }
    )
  )
)
