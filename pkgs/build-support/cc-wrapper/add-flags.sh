# Prepare policy locally. Explicit child bindings transport it without changing caller inputs.
var_templates_list=(
    NIX_CFLAGS_COMPILE
    NIX_CFLAGS_COMPILE_BEFORE
    NIX_CFLAGS_LINK
    NIX_CXXSTDLIB_COMPILE
    NIX_CXXSTDLIB_LINK
    NIX_GNATFLAGS_COMPILE
    NIX_FFLAGS_COMPILE
    NIX_FFLAGS_COMPILE_BEFORE
)
var_templates_bool=(
    NIX_ENFORCE_NO_NATIVE
)

accumulateRoles

# We need to mangle names for hygiene, but also take parameters/overrides
# from the environment.
for var in "${var_templates_list[@]}"; do
    mangleVarList "$var" ${role_suffixes[@]+"${role_suffixes[@]}"}
done
for var in "${var_templates_bool[@]}"; do
    mangleVarBool "$var" ${role_suffixes[@]+"${role_suffixes[@]}"}
done

# Prepending `@bintools@/bin' to $PATH forces cc to use ld-wrapper.sh when calling ld.
# $path_backup is where cc-wrapper.sh stores the $PATH that will be used for the
# compiler invocation.
path_backup="@bintools@/bin:$path_backup"

# wrapperCompileFlags assembles the suppressible defaults in their required
# order when the individual compiler invocation is interpreted.
if [ -e @out@/nix-support/cc-cflags ]; then
    wrapper_NIX_CFLAGS_COMPILE="$(< @out@/nix-support/cc-cflags) $wrapper_NIX_CFLAGS_COMPILE"
fi

# Keep defaults which an individual compiler invocation can suppress separate
# until that invocation's arguments have been interpreted. GNAT deliberately
# prepares an empty libc component for all of its compiler jobs.
wrapper_CC_LIBC_FLAGS=
if [[ "$cInclude" = 1 && -e @out@/nix-support/libc-cflags ]]; then
    wrapper_CC_LIBC_FLAGS="$(< @out@/nix-support/libc-cflags)"
fi
wrapper_CC_CRT_FLAGS=
if [[ -e @out@/nix-support/libc-crt1-cflags ]]; then
    wrapper_CC_CRT_FLAGS="$(< @out@/nix-support/libc-crt1-cflags)"
fi

if [ -e @out@/nix-support/libcxx-cxxflags ]; then
    wrapper_NIX_CXXSTDLIB_COMPILE+=" $(< @out@/nix-support/libcxx-cxxflags)"
fi

if [ -e @out@/nix-support/libcxx-ldflags ]; then
    wrapper_NIX_CXXSTDLIB_LINK+=" $(< @out@/nix-support/libcxx-ldflags)"
fi

if [ -e @out@/nix-support/gnat-cflags ]; then
    wrapper_NIX_GNATFLAGS_COMPILE="$(< @out@/nix-support/gnat-cflags) $wrapper_NIX_GNATFLAGS_COMPILE"
fi

if [ -e @out@/nix-support/cc-ldflags ]; then
    wrapper_NIX_LDFLAGS+=" $(< @out@/nix-support/cc-ldflags)"
fi

if [ -e @out@/nix-support/cc-cflags-before ]; then
    wrapper_NIX_CFLAGS_COMPILE_BEFORE="$(< @out@/nix-support/cc-cflags-before) $wrapper_NIX_CFLAGS_COMPILE_BEFORE"
fi

# Only add darwin min version flag if a default darwin min version is set,
# which is a signal that we're targetting darwin.
if [ "@darwinMinVersion@" ]; then
    mangleVarSingle @darwinMinVersionVariable@ ${role_suffixes[@]+"${role_suffixes[@]}"}

    wrapper_@darwinMinVersionVariable@=${wrapper_@darwinMinVersionVariable@:-@darwinMinVersion@}
    wrapper_NIX_CFLAGS_COMPILE_BEFORE="-m@darwinPlatformForCC@-version-min=${wrapper_@darwinMinVersionVariable@:-@darwinMinVersion@} $wrapper_NIX_CFLAGS_COMPILE_BEFORE"
fi
