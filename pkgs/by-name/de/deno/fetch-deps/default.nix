{
  lib,
  stdenv,
  deno,
  jq,
}:
{
  hash ? "",
  pname,
  denoLock ? "",
  denoJson ? "",
  denoEntrypoints ? [ ],
  preDenoInstall ? "",
  denoInstallFlags ? [ ],
  ...
}@args:
let
  args' = builtins.removeAttrs args [
    "hash"
    "pname"
  ];
in
stdenv.mkDerivation (
  args'
  // {
    name = "${pname}-deno-deps";

    nativeBuildInputs = [
      deno
      jq
    ];

    dontConfigure = true;
    dontBuild = true;

    denoInstallFlags =
      (lib.cli.toGNUCommandLine { } {
        vendor = true;
        frozen = true;
        node-modules-dir = true;
        entrypoint = if denoEntrypoints == [ ] then null else denoEntrypoints;
      })
      ++ denoInstallFlags;

    inherit denoLock denoJson denoEntrypoints;

    installPhase = ''
      export DENO_DIR=$(mktemp -d)
      export DENO_NO_UPDATE_CHECK=true

      if [[ -z "$denoLock" ]]; then
        echo "autodetecting lock file"
      else
        if [[ ! -f "$denoLock" ]]; then
          echo "error: lock file '$denoLock' is specified but not found" >&2
          exit 1
        fi
        cp "$denoLock" deno.lock
      fi

      if [[ -z "$denoJson" ]]; then
        echo "autodetecting Deno config"
      else
        if [[ ! -f "$denoJson" ]]; then
          echo "error: Deno config '$denoJson' is specified but not found" >&2
          exit 1
        fi
        cp "$denoJson" deno.json
      fi

      for entrypoint in "''${denoEntrypoints[@]}"; do
        if [[ -n "$entrypoint" && ! -f "$entrypoint" ]]; then
          echo "error: entrypoint '$entrypoint' is specified but not found" >&2
          exit 1
        fi
      done

      ${preDenoInstall}

      deno install ''${denoInstallFlags[@]}

      # Remove redundant & unreproducible files
      rm -f node_modules/.deno/.deno.lock{,.poll}

      # TODO: I'm not exactly sure if this is necessary anymore
      if [[ -f vendor/manifest.json ]]; then
        jq -S '.' vendor/manifest.json > vendor/manifest.json.tmp
        mv vendor/manifest.json.tmp vendor/manifest.json
      fi


      mkdir -p $out
      [[ -d node_modules ]] && cp -a node_modules -t $out || true
      [[ -d vendor ]] && cp -a vendor -t $out || true
      [[ -n deno.json ]] && cp deno.json -t $out || true
      [[ -n deno.lock ]] && cp deno.lock -t $out || true
    '';

    dontFixup = true;

    outputHash = hash;
    outputHashMode = "recursive";
  }
  // lib.optionalAttrs (hash == "") {
    outputHashAlgo = "sha256";
  }
)
