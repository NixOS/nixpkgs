# shellcheck shell=bash

denoCompileBuildPhase() {
    export DENORT_BIN="@deno@/bin/denort"
    export DENO_COMPILE_OUT=$(mktemp -d)

    if [[ -z "${denoCompileEntrypoints[@]}" ]]; then
        if [[ -z "${denoEntrypoints[@]}" ]]; then
            echo "error: neither denoEntrypoints nor denoCompileEntrypoints is set - can't compile anything!" >&2
            exit 1
        fi

        denoCompileEntrypoints=("${denoEntrypoints[@]}")
    fi
    for entrypoint in "${denoCompileEntrypoints[@]}"; do
      if [[ -n "$entrypoint" && ! -f "$entrypoint" ]]; then
        echo "error: entrypoint '$entrypoint' is specified but not found" >&2
        exit 1
      fi
    done

    deno compile \
        --output $DENO_COMPILE_OUT/ \
        --cached-only \
        --vendor \
        --node-modules-dir \
        ${denoCompileFlags[@]} \
        ${denoCompileEntrypoints[@]}

    # `deno compile` works by inserting JavaScript in the data segments of the executables.
    # Stripping them would just completely defeat the point and render the executable unusable.
    for file in $DENO_COMPILE_OUT/*; do
        stripExclude+=("${file#"$DENO_COMPILE_OUT/"}")
    done
}

denoCompileInstallPhase() {
    mkdir -p $out/bin
    cp -a $DENO_COMPILE_OUT/. -t $out/bin
}

# Why don't we have any kind of dontDenoCompile flag? Because if you don't want to run `deno compile`,
# you shouldn't include this hook in your nativeBuildInputs. Simple as.
if [[ -z "${buildPhase-}" ]]; then
    setOutputFlags=
    buildPhase=denoCompileBuildPhase
fi
if [[ -z "${installPhase-}" ]]; then
    setOutputFlags=
    installPhase=denoCompileInstallPhase
fi
