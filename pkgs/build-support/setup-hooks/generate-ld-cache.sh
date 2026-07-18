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
    # dontGenerateLDCache is this hook's own, purpose-built opt-out; always
    # honour it. dontPatchELF alone is *not* a reliable signal to also skip:
    # it only gates patchelf's own --shrink-rpath pass (patchelf/setup-hook.sh),
    # not autoPatchelfHook's interpreter/RPATH rewrite (gated separately by
    # dontAutoPatchelf). If autoPatchelfHook is active it still finalises the
    # ELF before this hook runs (see the ordering comment above), so the note
    # it would produce is correct regardless of dontPatchELF -- e.g. the
    # dotnet SDK sets dontPatchELF for an unrelated RPATH-preservation reason
    # but still runs autoPatchelfHook, and must not be excluded on that basis.
    # Only skip on dontPatchELF when autoPatchelfHook additionally will not
    # run either, which is the genuine "keep patchelf away from this binary
    # entirely" case (e.g. ghc's Android-prebuilt binaries).  autoPatchelfHook
    # presence is detected via its documented `autoPatchelf` command, not its
    # private postFixup function, whose name auto-patchelf.sh itself plans to
    # retire (see the XXX comment there).
    if [ -n "${dontGenerateLDCache-}" ]; then return 0; fi
    if [ -n "${dontPatchELF-}" ] \
        && { [ -n "${dontAutoPatchelf-}" ] || ! declare -F autoPatchelf > /dev/null; }; then
        return 0
    fi

    local -a patchelfFlagsArray=()
    concatTo patchelfFlagsArray patchelfFlags
    # Forward a package's own patchelfFlags (e.g. --no-clobber-old-sections,
    # which firefox-family packages rely on to protect relrhack's manually
    # laid-out relocations) so this hook's own patchelf invocation doesn't
    # undo protections the package already asked for. --force-rpath is
    # dropped because patchelf refuses to combine it with
    # --build-resolution-cache; nothing in nixpkgs sets both today, but don't
    # propagate a combination patchelf itself rejects.
    local -a ldCacheFlags=()
    local flag
    for flag in "${patchelfFlagsArray[@]}"; do
        [ "$flag" = "--force-rpath" ] && continue
        ldCacheFlags+=("$flag")
    done

    local output
    for output in $(getAllOutputNames); do
        generateLDCache "${!output}" "${ldCacheFlags[@]}"
    done
}

# Only ET_EXEC (2) and ET_DYN (3) objects can have DT_NEEDED entries.  Feeding
# anything else to patchelf (ET_REL relocatable objects such as glibc's crt*.o
# or kernel modules) makes it abort with "wrong ELF type" and print a spurious
# per-file warning below for a file that was never going to need a note.
_isELFLoadable() {
    local bytes
    local -a b
    # Bytes 0 to 17 of the ELF header: e_ident[EI_DATA] at index 5 gives the
    # byte order (1 is LSB, 2 is MSB); e_type is the half word at offset 16 in
    # the file's own byte order.
    bytes=$(od -A n -N 18 -t u1 "$1" | tr '\n' ' ')
    read -r -a b <<< "$bytes"
    local etype
    byte_order="${b[5]:-0}"
    case "${byte_order}" in
    1)
        etype=$(( ${b[16]:-0} + ${b[17]:-0} * 256 ))
        ;;
    2)
        etype=$(( ${b[16]:-0} * 256 + ${b[17]:-0} ))
        ;;
    *)
        printf "Unknown byte order value: %q\n" "${byte_order}"
        return 1
        ;;
    esac
    [ "$etype" -eq 2 ] || [ "$etype" -eq 3 ]
}

generateLDCache() {
    local dir="$1"
    shift
    local -a extraFlags=("$@")
    [ -e "$dir" ] || return 0

    local i
    local -a elfs=()
    # Exclude only files inside a .build-id/ directory component (debug-info
    # hardlink trees, same idiom as audit-tmpdir.sh); a substring match would
    # silently skip legitimately named files like libfoo.build-id-helper.so.
    while IFS= read -r -d '' i; do
        if ! isELF "$i" || ! _isELFLoadable "$i"; then continue; fi
        elfs+=("$i")
    done < <(find "$dir" -type f -not -path '*/.build-id/*' -print0)

    [ "${#elfs[@]}" -eq 0 ] && return 0

    echo "generating LD cache for ${#elfs[@]} ELF file(s) in $dir"
    # The cache is only a resolution hint; the patched loader falls back to the
    # normal RUNPATH walk without it, so a file that simply cannot get a note
    # is non-fatal.  Run patchelf once per file rather than batching many
    # files into one invocation: patchelf has no per-file exception handling,
    # so a single file that trips one of its internal errors aborts its whole
    # process, which would silently leave every file ordered after it in a
    # shared batch without a note.  Warn per file, naming the file, so
    # regressions are attributable instead of anonymous.
    #
    # One failure is fatal: a pre-existing note that no longer matches
    # (patchelf: "a resolution cache note is already present") means a
    # note-unaware tool rewrote this binary after its note was generated, and
    # the patched loader would trust the stale resolution over the binary's
    # actual RUNPATH.  Shipping that is silent misresolution, so fail the
    # build.  The string match is coupled to patchelf's wording
    # (src/patchelf.cc); if it ever drifts we degrade to the warning, never
    # to a spurious failure.
    local f err
    for f in "${elfs[@]}"; do
        if err=$(@patchelf@ "${extraFlags[@]}" --build-resolution-cache "$f" 2>&1); then
            if [ -n "$err" ]; then printf '%s\n' "$err" >&2; fi
        else
            printf '%s\n' "$err" >&2
            if [[ "$err" == *"resolution cache note is already present"* ]]; then
                echo "error: stale resolution-cache note on $f;" \
                    "a note-unaware patchelf rewrote this binary after its note was generated." \
                    "Rebuild it from an unpatched original or set dontGenerateLDCache." >&2
                exit 1
            fi
            echo "warning: ld cache generation failed for $f" >&2
        fi
    done
}
