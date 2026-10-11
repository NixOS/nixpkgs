# N.B. It may be a surprise that the derivation-specific variables are exported,
# since this is just sourced by the wrapped binaries---the end consumers. This
# is because one wrapper binary may invoke another (e.g. cc invoking ld). In
# that case, it is cheaper/better to not repeat this step and let the forked
# wrapped binary just inherit the work of the forker's wrapper script.

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

# Export and assign separately in order that a failing $(..) will fail
# the script.

# Currently bootstrap-tools does not split glibc, and gcc files into
# separate directories. As a workaround we want resulting cflags to be
# ordered as: crt1-cflags libc-cflags cc-cflags. Otherwise we mix crt/libc.so
# from different libc as seen in
#   https://github.com/NixOS/nixpkgs/issues/158042
#
# Note that below has reverse ordering as we prepend flags one-by-one.
# Once bootstrap-tools is split into different directories we can stop
# relying on flag ordering below.

if [ -e @out@/nix-support/cc-cflags ]; then
    NIX_CFLAGS_COMPILE_@suffixSalt@="$(< @out@/nix-support/cc-cflags) $NIX_CFLAGS_COMPILE_@suffixSalt@"
fi

if [[ "$cInclude" = 1 ]] && [ -e @out@/nix-support/libc-cflags ]; then
    NIX_CFLAGS_COMPILE_@suffixSalt@="$(< @out@/nix-support/libc-cflags) $NIX_CFLAGS_COMPILE_@suffixSalt@"
fi

if [ -e @out@/nix-support/libc-crt1-cflags ]; then
    NIX_CFLAGS_COMPILE_@suffixSalt@="$(< @out@/nix-support/libc-crt1-cflags) $NIX_CFLAGS_COMPILE_@suffixSalt@"
fi

# Flang reads its flags from NIX_FFLAGS_COMPILE instead of NIX_CFLAGS_COMPILE
# (see the isFlang branch in cc-wrapper.sh).  The generic wrapper-generated
# flags above (-B paths for crt files, --gcc-toolchain, -resource-dir, etc.)
# are needed by all frontends, so mirror them into NIX_FFLAGS_COMPILE when
# isFlang is set.  Without this, flang cannot link because it never receives
# the -B paths needed to resolve crt objects (Scrt1.o, crti.o, crtbeginS.o).
# gfortran avoids this by not setting isFlang and reading from
# NIX_CFLAGS_COMPILE directly.
if [ "@isFlang@" = 1 ]; then
    NIX_FFLAGS_COMPILE_@suffixSalt@="$NIX_CFLAGS_COMPILE_@suffixSalt@ $NIX_FFLAGS_COMPILE_@suffixSalt@"
fi

if [ -e @out@/nix-support/libcxx-cxxflags ]; then
    NIX_CXXSTDLIB_COMPILE_@suffixSalt@+=" $(< @out@/nix-support/libcxx-cxxflags)"
fi

if [ -e @out@/nix-support/libcxx-ldflags ]; then
    NIX_CXXSTDLIB_LINK_@suffixSalt@+=" $(< @out@/nix-support/libcxx-ldflags)"
fi

if [ -e @out@/nix-support/gnat-cflags ]; then
    NIX_GNATFLAGS_COMPILE_@suffixSalt@="$(< @out@/nix-support/gnat-cflags) $NIX_GNATFLAGS_COMPILE_@suffixSalt@"
fi

if [ -e @out@/nix-support/cc-ldflags ]; then
    NIX_LDFLAGS_@suffixSalt@+=" $(< @out@/nix-support/cc-ldflags)"
fi

if [ -e @out@/nix-support/cc-cflags-before ]; then
    NIX_CFLAGS_COMPILE_BEFORE_@suffixSalt@="$(< @out@/nix-support/cc-cflags-before) $NIX_CFLAGS_COMPILE_BEFORE_@suffixSalt@"
    if [ "@isFlang@" = 1 ]; then
        NIX_FFLAGS_COMPILE_BEFORE_@suffixSalt@="$NIX_CFLAGS_COMPILE_BEFORE_@suffixSalt@ $NIX_FFLAGS_COMPILE_BEFORE_@suffixSalt@"
    fi
fi

# Only add darwin min version flag if a default darwin min version is set,
# which is a signal that we're targetting darwin.
if [ "@darwinMinVersion@" ]; then
    mangleVarSingle @darwinMinVersionVariable@ ${role_suffixes[@]+"${role_suffixes[@]}"}

    NIX_CFLAGS_COMPILE_BEFORE_@suffixSalt@="-m@darwinPlatformForCC@-version-min=${@darwinMinVersionVariable@_@suffixSalt@:-@darwinMinVersion@} $NIX_CFLAGS_COMPILE_BEFORE_@suffixSalt@"
fi

# That way forked processes will not extend these environment variables again.
export NIX_CC_WRAPPER_FLAGS_SET_@suffixSalt@=1
