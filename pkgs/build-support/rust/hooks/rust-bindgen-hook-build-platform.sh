# When cross compiling, build scripts also compile crates for the build
# platform, which need the build platform's headers instead. bindgen prefers
# BINDGEN_EXTRA_CLANG_ARGS_<target> over the generic
# variable above, which then only serves the host platform.

populateBindgenBuildPlatformEnv () {
    BINDGEN_EXTRA_CLANG_ARGS_@buildRustTarget@="$(< @buildClang@/nix-support/cc-cflags) $(< @buildClang@/nix-support/libc-cflags) $(< @buildClang@/nix-support/libcxx-cxxflags) ${NIX_CFLAGS_COMPILE_FOR_BUILD-}"
    export BINDGEN_EXTRA_CLANG_ARGS_@buildRustTarget@
}

postHook="${postHook:-}"$'\n'"populateBindgenBuildPlatformEnv"$'\n'
