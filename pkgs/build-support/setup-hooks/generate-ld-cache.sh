# shellcheck shell=bash

# The NixOS resolution-cache note records, for each binary, the resolved paths
# of its DT_NEEDED libraries.  It must therefore be written only after every
# other tool that rewrites ELF files has finished, so that it reflects the final
# interpreter and RPATH.  In particular autoPatchelfHook rewrites those in
# postFixup, which runs after ordinary fixupOutput hooks; writing the note in
# fixupOutput would record pre-autoPatchelf state and leave a stale note on the
# final binary.
#
# We defer note generation to the end of postFixup.  Registering it from
# preFixup (which runs once, after every setup hook has been sourced) guarantees
# it is appended to postFixupHooks *after* autoPatchelfHook's own postFixup
# hook, which is appended at setup-hook source time.

preFixupHooks+=(_registerGenerateLDCache)

_registerGenerateLDCache() {
    postFixupHooks+=(_generateLDCacheAllOutputs)
}

_generateLDCacheAllOutputs() {
    # Honour dontPatchELF as well as our own opt-out: packages that keep patchelf
    # away from fragile or self-verifying binaries (e.g. ghc) must not have notes
    # written into them either, since writing the note rewrites the ELF.
    if [ -n "${dontGenerateLDCache-}" ] || [ -n "${dontPatchELF-}" ]; then return 0; fi
    local output
    for output in $(getAllOutputNames); do
        generateLDCache "${!output}"
    done
}

generateLDCache() {
    local dir="$1"
    [ -e "$dir" ] || return 0

    # Collect the ELF files and hand them to patchelf via xargs, which batches
    # them into as few invocations as fit within ARG_MAX rather than forking
    # once per file; this hook runs on every build.
    local i
    local -a elfs=()
    while IFS= read -r -d $'\0' i; do
        if [[ "$i" =~ \.build-id ]] || ! isELF "$i"; then continue; fi
        elfs+=("$i")
    done < <(find "$dir" -type f -print0)

    [ "${#elfs[@]}" -eq 0 ] && return 0

    echo "generating LD cache for ${#elfs[@]} ELF file(s) in $dir"
    # The cache is only a resolution hint; the patched loader falls back to the
    # normal RUNPATH walk without it, so a failure here is non-fatal.  Warn
    # rather than fail silently so regressions across the package set stay
    # observable.
    printf '%s\0' "${elfs[@]}" \
        | xargs -0 @patchelf@ --build-resolution-cache \
        || echo "warning: ld cache generation failed for $dir" >&2
}
