# shellcheck shell=bash

denoConfigHook() {
    echo "Executing denoConfigHook"

    if [[ -n "${denoRoot-}" ]]; then
      pushd "$denoRoot"
    fi

    if [[ -z "${denoDeps-}" ]]; then
      echo "denoDeps not set - skipping"
      exit 0
    fi

    export DENO_DIR=$(mktemp -d)

    if [[ -d $denoDeps/node_modules ]]; then
        cp -a $denoDeps/node_modules -t .
        chmod -R +w node_modules

        echo "Patching scripts"
        patchShebangs node_modules/{*,.*}
    fi

    [[ -d $denoDeps/vendor ]] && cp -a $denoDeps/vendor -t . || true
    [[ -f $denoDeps/deno.json ]] && cp $denoDeps/deno.json deno.json || true
    [[ -f $denoDeps/deno.lock ]] && cp $denoDeps/deno.lock deno.lock || true

    if [[ -n "${denoRoot-}" ]]; then
      popd
    fi

    echo "Finished denoConfigHook"
}

postConfigureHooks+=(denoConfigHook)
