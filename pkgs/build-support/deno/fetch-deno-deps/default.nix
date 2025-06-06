# NOTE: much of this structure is inspired from https://github.com/NixOS/nixpkgs/tree/fff29a3e5f7991512e790617d1a693df5f3550f6/pkgs/build-support/node
{
  lib,
  stdenvNoCC,
  deno,
  jq,
  cacert,
}:
{
  fetchDenoDeps =
    {
      name ? "deno-deps",
      src,
      hash ? lib.fakeHash,
      denoPackage ? deno,
      denoFlags ? [ ],
      denoInstallFlags ? [
        "--allow-scripts"
        "--frozen"
      ],
      nativeBuildInputs ? [ ],
      denoDepsImpureEnvVars ? [ ],
      denoDepsInjectedEnvVars ? { },
      denoDir ? "./.deno",
      ...
    }@args:
    let
      hash_ =
        if hash != "" then
          { outputHash = hash; }
        else
          {
            outputHash = "";
            outputHashAlgo = "sha256";
          };
      denoInstallFlags_ = builtins.concatStringsSep " " denoInstallFlags;
      denoFlags_ = builtins.concatStringsSep " " denoFlags;
      denoDepsInjectedEnvVarsString =
        if denoDepsInjectedEnvVars != { } then
          lib.attrsets.foldlAttrs (
            acc: name: value:
            "${acc} ${name}=${value}"
          ) "" denoDepsInjectedEnvVars
        else
          "";
      # need to remove denoDepsInjectedEnvVars, since it's an attrset and
      # stdenv.mkDerivation would try to convert it to string
      args' = builtins.removeAttrs args [ "denoDepsInjectedEnvVars" ];
    in
    stdenvNoCC.mkDerivation (
      args'
      // {
        inherit name src;

        nativeBuildInputs = nativeBuildInputs ++ [
          denoPackage
          jq
        ];

        DENO_DIR = denoDir;

        buildPhase = ''
          runHook preBuild

          if [[ ! -e "deno.json" ]]; then
            echo ""
            echo "ERROR: deno.json required, but not found"
            echo ""
            exit 1
          fi

          if [[ ! -e "deno.lock" ]]; then
            echo ""
            echo "ERROR: deno.lock required, but not found"
            echo ""
            exit 1
          fi

          # NOTE: using vendor reduces the pruning effort a little
          useVendor() {
              jq '.vendor = true' deno.json >temp.json && \
              rm -f deno.json && \
              mv temp.json deno.json
          }
          useVendor

          # uses $DENO_DIR
          ${denoDepsInjectedEnvVarsString} deno install ${denoInstallFlags_} ${denoFlags_}

          echo "pruning non reproducible files"

          # `node_modules` is used when there are install scripts in a dependencies' package.json.
          # these install scripts can also require internet, so they should also be executed in this fetcher
          pruneNonReproducibles() {
              export tempDenoDir="$DENO_DIR"

              # `registry.json` files can't just be deleted, else deno install won't work,
              # but they contain non reproducible data,
              # which needs to be pruned, leaving only the necessary data behind.
              # This pruning is done with a helper script written in typescript and executed with deno
              DENO_DIR=./extra_deno_cache deno run \
                --lock="${./deno.lock}" \
                --config="${./deno.json}" \
                --allow-all \
                "${./prune-registries.ts}" \
                --lock-json="./deno.lock" \
                --cache-path="$tempDenoDir" \
                --vendor-path="./vendor"

              # Keys in `registry.json` files are not deterministically sorted,
              # so we do it here.
              for file in $(find -L "$DENO_DIR" -name registry.json -type f); do
                  jq --sort-keys '.' "$file" >temp.json && \
                  rm -f "$file" && \
                  mv temp.json "$file"
              done

              # There are various small databases used by deno for caching that
              # we can simply delete.
              if [[ -d "./node_modules" ]]; then
                find -L ./node_modules -name '*cache_v2-shm' -type f | xargs rm -f
                find -L ./node_modules -name '*cache_v2-wal' -type f | xargs rm -f
                find -L ./node_modules -name 'dep_analysis_cache_v2' -type f | xargs rm -f
                find -L ./node_modules -name 'node_analysis_cache_v2' -type f | xargs rm -f
                find -L ./node_modules -name v8_code_cache_v2 -type f | xargs rm -f
                rm -f ./node_modules/.deno/.deno.lock.poll

                # sometimes a .deno dir is slipped into a node_modules package
                # it's unclear why. but it can just be deleted
                find -L ./node_modules -name ".deno" -type d | sort -r | head -n-1 | xargs rm -rf
              fi

              rm -f "$DENO_DIR"/dep_analysis_cache_v2-shm
              rm -f "$DENO_DIR"/dep_analysis_cache_v2-wal
              rm -f "$DENO_DIR"/dep_analysis_cache_v2
          }
          pruneNonReproducibles

          runHook postBuild
        '';

        installPhase = ''
          runHook preInstall

          if [[ -d "$DENO_DIR" ]]; then
            mkdir -p $out/$DENO_DIR
            cp -r --no-preserve=mode $DENO_DIR $out
          fi
          if [[ -d "./vendor" ]]; then
            mkdir -p $out/vendor
            cp -r --no-preserve=mode ./vendor $out
          fi
          if [[ -d "./node_modules" ]]; then
            mkdir -p $out/node_modules
            cp -r --no-preserve=mode ./node_modules $out
          fi

          cp ./deno.lock $out

          runHook postInstall
        '';

        dontFixup = true;

        outputHashMode = "recursive";

        impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ denoDepsImpureEnvVars;

        SSL_CERT_FILE =
          if
            (
              hash_.outputHash == ""
              || hash_.outputHash == lib.fakeSha256
              || hash_.outputHash == lib.fakeSha512
              || hash_.outputHash == lib.fakeHash
            )
          then
            "${cacert}/etc/ssl/certs/ca-bundle.crt"
          else
            "/no-cert-file.crt";

      }
      // hash_
    );
}
