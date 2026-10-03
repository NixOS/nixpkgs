# Compiler activation records every dependency role served by this wrapper and
# registers collectors for those roles. Several roles may use the same wrapper,
# including when their platforms are equal (see ../setup-hooks/role.bash).
# Collectors append to role-specific caller inputs such as NIX_CFLAGS_COMPILE
# and NIX_CFLAGS_COMPILE_FOR_BUILD; they do not select compiler defaults.
#
# At invocation, add-flags.sh combines active roles and salted caller inputs
# into a private policy record. It leaves the caller inputs unchanged. See
# ../wrapper-common/utils.bash and the manual's compiler-wrapper contract.

# Skip setup hook if we're neither a build-time dep, nor, temporarily, doing a
# native compile.
#
# TODO(@Ericson2314): No native exception
[[ -z ${strictDeps-} ]] || (( "$hostOffset" < 0 )) || return 0

# See ../setup-hooks/role.bash
getTargetRole
getTargetRoleWrapper

# We use the `targetOffset` to choose the right env hook to accumulate the right
# sort of deps (those with that offset).
source @out@/nix-support/add-env-hooks.sh

# Note 1: these come *after* $out in the PATH (see setup.sh).
# Note 2: phase separation makes this look useless to shellcheck.

# shellcheck disable=SC2157
if [ -n "@cc@" ]; then
    addToSearchPath _PATH @cc@/bin
fi

# shellcheck disable=SC2157
if [ -n "@libc_bin_for_host@" ]; then
    addToSearchPath _PATH @libc_bin_for_host@/bin
fi

# shellcheck disable=SC2157
if [ -n "@coreutils_bin@" ]; then
    addToSearchPath _PATH @coreutils_bin@/bin
fi

# Export tool environment variables so various build systems use the right ones.

export NIX_CC${role_post}=@out@

export CC${role_post}=@named_cc@
export CXX${role_post}=@named_cxx@

# If unset, assume the default hardening flags.
: ${NIX_HARDENING_ENABLE="@default_hardening_flags_str@"}
export NIX_HARDENING_ENABLE

# No local scope in sourced file
unset -v role_post
