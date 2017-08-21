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


# It's fine that any other cc-wrapper will redefine this. Bash functions close
# over no state, and there's no @-substitutions within, so any redefined
# function is guaranteed to be exactly the same.
ccWrapper_addCVars () {
    # The `depOffset` describes how the platforms of the dependencies are slid
    # relative to the depending package. It is brought into scope of the
    # environment hook defined as the role of the dependency being applied.
    case $depOffset in
        -1) local role='BUILD_' ;;
        0)  local role='' ;;
        1)  local role='TARGET_' ;;
        *)  echo "cc-wrapper: Error: Cannot be used with $depOffset-offset deps, " >2;
            return 1 ;;
    esac

    if [[ -d "$1/include" ]]; then
        export NIX_${role}CFLAGS_COMPILE+=" ${ccIncludeFlag:--isystem} $1/include"
    fi

    if [[ -d "$1/lib64" && ! -L "$1/lib64" ]]; then
        export NIX_${role}LDFLAGS+=" -L$1/lib64"
    fi

    if [[ -d "$1/lib" ]]; then
        export NIX_${role}LDFLAGS+=" -L$1/lib"
    fi

    if [[ -d "$1/Library/Frameworks" ]]; then
        export NIX_${role}CFLAGS_COMPILE+=" -F$1/Library/Frameworks"
    fi
}

# Since the same cc-wrapper derivation can be depend on in multiple ways, we
# need to accumulate *each* role (i.e. target platform relative the depending
# derivation) in which the cc-wrapper derivation is used.
# `NIX_CC_WRAPPER_@infixSalt@_TARGET_*` tracks this (needs to be an exported env
# var so can't use fancier data structures).
#
# We also need to worry about what role is being added on *this* invocation of
# setup-hook, which `role` tracks.
if [ -n "${crossConfig:-}" ]; then
    export NIX_CC_WRAPPER_@infixSalt@_TARGET_BUILD=1
    role="BUILD_"
else
    export NIX_CC_WRAPPER_@infixSalt@_TARGET_HOST=1
    role=""
fi

# Eventually the exact sort of env-hook we create will depend on the role. This
# is because based on what relative platform we are targeting, we use different
# dependencies.
envHooks+=(ccWrapper_addCVars)

# Note 1: these come *after* $out in the PATH (see setup.sh).
# Note 2: phase separation makes this look useless to shellcheck.

# shellcheck disable=SC2157
if [ -n "@cc@" ]; then
    addToSearchPath _PATH @cc@/bin
fi

# shellcheck disable=SC2157
if [ -n "@binutils_bin@" ]; then
    addToSearchPath _PATH @binutils_bin@/bin
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

export NIX_${role}CC=@out@

export ${role}CC=@named_cc@
export ${role}CXX=@named_cxx@

for CMD in \
    ar as nm objcopy ranlib strip strings size ld windres
do
    if
        PATH=$_PATH type -p "@binPrefix@$CMD" > /dev/null
    then
        export "${role}$(echo "$CMD" | tr "[:lower:]" "[:upper:]")=@binPrefix@${CMD}";
    fi
done

# No local scope in sourced file
unset role
