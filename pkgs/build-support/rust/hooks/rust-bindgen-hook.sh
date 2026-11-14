# populates LIBCLANG_PATH and BINDGEN_EXTRA_CLANG_ARGS for rust projects that
# depend on the bindgen crate

# if you modify this, you probably also need to modify the wrapper for the cli
# of bindgen in pkgs/development/tools/rust/bindgen/wrapper.sh

populateBindgenEnv () {
    export LIBCLANG_PATH=@libclang@/lib
    local providerFlags
    if [[ -n "@importerDriverFlags@" ]]; then
      providerFlags="--config=@clang@/nix-support/@importerDriverFlags@"
    else
      providerFlags="$(< @clang@/nix-support/@libcFlags@) $(< @clang@/nix-support/@cxxFlags@)"
    fi
    BINDGEN_EXTRA_CLANG_ARGS="@targetFlag@ $providerFlags $(< @clang@/nix-support/cc-cflags) $NIX_CFLAGS_COMPILE"
    export BINDGEN_EXTRA_CLANG_ARGS
}

postHook="${postHook:-}"$'\n'"populateBindgenEnv"$'\n'
