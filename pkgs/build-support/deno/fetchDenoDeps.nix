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
  mainScript ? "",
  # The deno.json config file. Leave unset to use denos default behavior (search for deno.json and deno.jsonc next to the script)
  denoJson ? "",
  # Customize the deno lockfile location.  Leave unset to use denos default behavior (search for deno.lock next to the script)
  denoLock ? "",
  ...
}@args:
stdenvNoCC.mkDerivation (
  finalAttrs:
  (
    args
    // {
      pname = if args ? pname && args.pname != null then "${args.pname}-deno-deps" else "deno-deps";
      name =
        if args ? name && args.name != null then
          "${args.name}-deno-deps"
        else
          "${finalAttrs.pname}-${finalAttrs.version}";

      denoJson = denoJson;
      denoLock = denoLock;
      mainScript = mainScript;

      nativeBuildInputs = [
        deno
        jq
        gnused
        coreutils
      ];

      buildPhase = ''
        ERROR_OCCURRED=false

        if test -z "$mainScript" ; then
          echo "error: You need to specify a deno main script. It is probably something like 'main.ts'" >&2
          echo "fix: Adjust you nix code to pass a main script as script." >&2
          exit 1
        fi
        if ! test -f "$mainScript" ; then
          echo "error: The script '$mainScript' for your application does not exist." >&2
          echo "fix: Run 'echo \"console.log(\\\"Hello world!\\\")\" > $mainScript' to create it." >&2
          exit 1
        fi

        SCRIPT_DIR="$(dirname "$mainScript")"

        # Resolve the deno json file. We need it to resolve the lockfile
        if test -n "$denoJson" ; then
          if ! test -f "$denoJson" ; then
            if test "$denoJson" = "deno.json" ; then
              echo "error: There is no deno config file in your project, but you explicitly specified '$denoJson'." >&2
              echo "fix: Run 'deno init' to create it." >&2
              echo "fix: Or remove the denoJson attribute from your nix code to use the default or none." >&2
            else
              echo "error: The deno config file at '$denoJson' you specified does not exist." >&2
              echo "fix: Create '$denoJson'." >&2
              echo "fix: Or remove the denoJson attribute from your nix code to use the default or none." >&2
            fi
            exit 1
          fi
        fi
        # If the deno json file is not set, we try the default locations
        implicitDenoJson="$denoJson"
        if test -z "$implicitDenoJson" ; then
          if test -f "$SCRIPT_DIR/$deno.json" ; then
            implicitDenoJson="$(realpath -s --relative-to . "$SCRIPT_DIR/deno.json")"
          elif test -f "$SCRIPT_DIR/deno.jsonc" ; then
            implicitDenoJson="$(realpath -s --relative-to . "$SCRIPT_DIR/deno.jsonc")"
          fi
        fi

        # If a deno json is to be used, implicitDenoJson is set at this point
        # If it is set, the file is guaranteed to exist


        if test -n "$denoLock" ; then
          if ! test -f "$denoLock" ; then
            echo "error: The deno lock file at '$denoLock' you explicitly requested does not exist." >&2
            echo "fix: Create '$denoLock'." >&2
            echo "fix: Or remove the denoLock attribute from your nix code to use the default one." >&2
            exit 1
          fi
        fi
        implicitDenoLock="$denoLock"
        # If the lockfile is not set, try to read its path from the deno json file
        if test -z "$implicitDenoLock" ; then
          if test -n "$implicitDenoJson" ; then
            implicitDenoLock="$(jq -r '.lock' "$implicitDenoJson" | sed 's/^null//')"
            if ! test -f "$implicitDenoLock" ; then
              echo "error: The deno lock file at '$implicitDenoLock' that was specified in '$implicitDenoJson' does not exist." >&2
              echo "fix: Run 'deno cache -c \"$implicitDenoJson\" $mainScript' to create it." >&2
              exit 1
            fi
          fi
        fi
        # If the lockfile is still not set, try the default location
        if test -z "$implicitDenoLock" ; then
          if test -f "$SCRIPT_DIR/deno.lock" ; then
            implicitDenoLock="$(realpath -s --relative-to . "$SCRIPT_DIR/deno.lock")"
          fi
        fi
        if test -z "$implicitDenoLock" ; then
          echo "error: There is no deno lock file in your project." >&2
          echo "fix: Run 'deno cache $mainScript' to create it." >&2
          exit 1
        fi

        # implicitDenoJson is always set to an existing file at this point, or to an empty string if it is not used
        # implicitDenoLock is always set to an existing file at this point

        DENO_FLAGS=""
        if test -n "$implicitDenoJson" ; then
          DENO_FLAGS+="-c $implicitDenoJson "
        fi
        DENO_FLAGS+="--lock $implicitDenoLock "

        export DENO_DIR="$(mktemp -d)"
        export DENO_NO_UPDATE_CHECK=true
        export DENO_NO_PACKAGE_JSON=true
        export DENO_JOBS=1

        mkdir node_modules
        mkdir vendor
        mkdir deno

        if test "$ERROR_OCCURRED" = "true" ; then
          exit 1
        fi

        export LOCKFILE_HASH=$(sha256sum "$implicitDenoLock" | cut -d' ' -f1)

        deno cache $DENO_FLAGS --vendor --node-modules-dir "$mainScript"
        # # This fun dance, makes the cache command run a second time, because the DENO_DIR is not reproducible otherwise.
        # # We dont need it for now, because we only take the relevant files from the DENO_DIR
        # rm -rf deno
        # mkdir deno
        # deno cache $DENO_FLAGS --vendor --node-modules-dir "$mainScript"

        LOCKFILE_HASH_AFTER=$(sha256sum "$implicitDenoLock" | cut -d' ' -f1)

        if test "$LOCKFILE_HASH" != "$LOCKFILE_HASH_AFTER" ; then
          echo "error: Your lockfile changed while running 'deno cache $mainScript'. We cant do reproducible builds this way. You probably have unlocked imports somewhere in your code. To fix this run 'deno cache $mainScript' and commit the changed lockfile." >&2
          echo "fix: Run 'deno cache $mainScript' and commit the changed lockfile." >&2
          ERROR_OCCURRED=true
        fi

        # These two files are not always reproducible and also not required
        rm node_modules/.deno/.deno.lock.poll || true
        rm node_modules/.deno/.deno.lock || true

        # This one is different on every build. There is a open PR to fix this
        # https://github.com/denoland/deno/issues/24479
        # rm node_modules/.deno/.setup-cache.bin || true

        # Make the symlinks in node_modules relative
        for link in $(find . -type l | sort) ; do
          ln --force --symbolic --no-dereference --relative "$(readlink --canonicalize "$link")" "$link"
        done

        # Sort the keys in the manifest file
        # TODO: Fix upstream
        if test -f vendor/manifest.json ; then
          jq -S '.' "vendor/manifest.json" > "vendor/manifest.json.tmp"
          mv "vendor/manifest.json.tmp" "vendor/manifest.json"
        fi

        # Filter the files in DENO_DIR that we actually need
        # We actually only need the nodejs registry.json files and only the relevant entries in them
        OLD_DENO_DIR="$DENO_DIR"
        export DENO_DIR="$(mktemp -d)"
        # We do this weird dance with jq to make sure the content of the files is sorted, because by default they are not. 
        for registry_file in $(find $OLD_DENO_DIR/npm -type f -name 'registry.json' | sed "s|^$OLD_DENO_DIR||g" | sort) ; do
          target_file="$DENO_DIR/$registry_file"
          package_name="$(jq -r '.name' "$OLD_DENO_DIR/$registry_file")"
          package_folder_prefix="node_modules/.deno/$(echo "$package_name" | sed 's|/|+|g')@"
          relevant_package_versions="$(echo ''${package_folder_prefix}* | sed "s|$package_folder_prefix\([^ ]*\)|\"\1\",|g")"

          mkdir -p "$(dirname "$target_file")"
          jq -S '.versions = ( .versions | with_entries( select(.key == ('"$relevant_package_versions"' "other")) ) )' "$OLD_DENO_DIR/$registry_file" > "$target_file"
        done

        if test -f vendor/manifest.json ; then
          for import in $(cat vendor/manifest.json | jq -r '.modules | keys[]') ; do
            warning="$(cat vendor/manifest.json | jq -r '.modules["'"$import"'"].headers["x-deno-warning"]' || true)"
            if test -z "$warning" || test "$warning" = "null" ; then
              continue
            fi
            echo "error: Import of '$import' produced a warning. This usually means, that your import is not locked. While this does not always affect reproducibility, it significantly increases the chance of weird errors if we allowed this. You don't like weird bugs, do you? For this reason I am now aborting your build and forcing you to fix it." >&2
            echo "reference: $warning" >&2
            echo "fix: Add the import to your deno config file and lock it by running 'deno add \"$import\"'" >&2
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

        # Place some infos about the build in out
        deno -v > $out/deno.info
        echo ${stdenvNoCC.targetPlatform.system} > $out/system.info

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
