# CC Wrapper hygiene
#
# For at least cross compilation, we need to depend on multiple cc-wrappers at
# once---specifically up to one per sort of dependency. This follows from having
# different tools targeting different platforms, and different flags for those
# tools. For example:
#
#   # Flags for compiling (whether or not linking) C code for the...
#   NIX_BUILD_CFLAGS_COMPILE  # ...build platform
#   NIX_CFLAGS_COMPILE        # ...host platform
#   NIX_TARGET_CFLAGS_COMPILE # ...target platform
#
# Notice that these platforms are the 3 *relative* to the package using
# cc-wrapper, not absolute like `x86_64-pc-linux-gnu`.
#
# The simplest solution would be to have separate cc-wrappers per (3 intended
# use-cases * n absolute concrete platforms). For the use-case axis, we would
# @-splice in 'BUILD_' '' 'TARGET_' to use the write environment variables when
# building the cc-wrapper, and likewise prefix the binaries' names so they didn't
# clobber each other on the PATH. But the need for 3x cc-wrappers, along with
# non-standard name prefixes, is annoying and liable to break packages' build
# systems.
#
# Instead, we opt to have just one cc-wrapper per absolute platform. Matching
# convention, the binaries' names can just be prefixed with their target
# platform. On the other hand, that means packages will depend on not just
# multiple cc-wrappers, but the exact same cc-wrapper derivation multiple ways.
# That means the exact same cc-wrapper derivation must be able to avoid
# conflicting with itself, despite the fact that `setup-hook.sh`, the `addCvars`
# function, and `add-flags.sh` are all communicating with each other with
# environment variables. Yuck.
#
# The basic strategy is:
#
#  - Everyone exclusively *adds information* to relative-platform-specific
#    environment variables, like `NIX_TARGET_CFLAGS_COMPILE`, to communicate
#    with the wrapped binaries.
#
#  - The wrapped binaries will exclusively *read* cc-wrapper-derivation-specific
#    environment variables distinguished with with `infixSalt`, like
#    `NIX_@infixSalt@_CFLAGS_COMPILE`.
#
#  - `add-flags`, beyond its old task of reading extra flags stuck inside the
#    cc-wrapper derivation, will convert the relative-platform-specific
#    variables to cc-wrapper-derivation-specific variables. This conversion is
#    the only time all but one of the cc-wrapper-derivation-specific variables
#    are set.
#
# This ensures the flow of information is exclusive from
# relative-platform-specific variables to cc-wrapper-derivation-specific
# variables. This allows us to support the general case of a many--many relation
# between relative platforms and cc-wrapper derivations.
#
# For more details, read the individual files where the mechanisms used to
# accomplish this will be individually documented.

set -u

# Skip setup hook if we're neither a build-time dep, nor, temporarily, doing a
# native compile.
#
# TODO(@Ericson2314): No native exception
[[ -z ${strictDeps-} ]] || (( "$hostOffset" < 0 )) || return 0

# It's fine that any other cc-wrapper will redefine this. Bash functions close
# over no state, and there's no @-substitutions within, so any redefined
# function is guaranteed to be exactly the same.
ccWrapper_addCVars () {
    # See ../setup-hooks/role.bash
    local role_post role_pre
    getHostRoleEnvHook

    if [[ -d "$1/include" ]]; then
        export NIX_${role_pre}CFLAGS_COMPILE+=" ${ccIncludeFlag:--isystem} $1/include"
    fi

    if [[ -d "$1/Library/Frameworks" ]]; then
        export NIX_${role_pre}CFLAGS_COMPILE+=" -F$1/Library/Frameworks"
    fi
}

# See ../setup-hooks/role.bash
getTargetRole
getTargetRoleWrapper

# We use the `targetOffset` to choose the right env hook to accumulate the right
# sort of deps (those with that offset).
addEnvHooks "$targetOffset" ccWrapper_addCVars

# Note 1: these come *after* $out in the PATH (see setup.sh).
# Note 2: phase separation makes this look useless to shellcheck.

# shellcheck disable=SC2157
if [ -n "@cc@" ]; then
    addToSearchPath _PATH @cc@/bin
fi

# shellcheck disable=SC2157
if [ -n "@libc_bin@" ]; then
    addToSearchPath _PATH @libc_bin@/bin
fi

# shellcheck disable=SC2157
if [ -n "@coreutils_bin@" ]; then
    addToSearchPath _PATH @coreutils_bin@/bin
fi

# Export tool environment variables so various build systems use the right ones.

export NIX_${role_pre}CC=@out@

export ${role_pre}CC=@out@/bin/@named_cc@
export ${role_pre}CXX=@out@/bin/@named_cxx@
export CC${role_post}=@out@/bin/@named_cc@
export CXX${role_post}=@out@/bin/@named_cxx@

# If unset, assume the default hardening flags.
: ${NIX_HARDENING_ENABLE="fortify stackprotector pic strictoverflow format relro bindnow"}
export NIX_HARDENING_ENABLE

# No local scope in sourced file
unset -v role_pre role_post
set +u
