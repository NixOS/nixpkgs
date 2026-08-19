# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: Lily Foster <lily@lily.flowers>
# Portions of this code are adapted from nixos-cosmic
# https://github.com/lilyinstarlight/nixos-cosmic

# shellcheck shell=bash
libcosmicAppWrapperArgs=()
libcosmicAppWrapHookRanFor=()

libcosmicAppVergenHook() {
    if [ -z "${VERGEN_GIT_COMMIT_DATE-}" ]; then
        # shellcheck disable=SC2155
        export VERGEN_GIT_COMMIT_DATE="$(date --utc --date=@"$SOURCE_DATE_EPOCH" '+%Y-%m-%d')"
    fi
}

libcosmicAppLinkerArgsHook() {
    # Force linking to certain libraries like libEGL, which are always dlopen()ed
    local flags="CARGO_TARGET_@cargoLinkerVar@_RUSTFLAGS"

    export "$flags"="${!flags-} -C link-arg=-Wl,--push-state,--no-as-needed"
    # shellcheck disable=SC2043
    for lib in @cargoLinkLibs@; do
        export "$flags"="${!flags} -C link-arg=-l${lib}"
    done
    export "$flags"="${!flags} -C link-arg=-Wl,--pop-state"
}

preConfigurePhases+=" libcosmicAppVergenHook libcosmicAppLinkerArgsHook"

# Add shell hook for use in dev shells
if [ -n "${IN_NIX_SHELL-}" ] && [ -z "${shellHook-}" ]; then
    shellHook="libcosmicAppLinkerArgsHook && export RUSTFLAGS=\$CARGO_TARGET_@cargoLinkerVar@_RUSTFLAGS CARGO_TARGET_@cargoLinkerVar@_RUSTFLAGS="
fi

libcosmicAppWrapperArgsHook() {
    if [ -d "${prefix:?}/share" ]; then
        libcosmicAppWrapperArgs+=(--suffix XDG_DATA_DIRS : "$prefix/share")
    fi

    # add fallback schemas, icons, and settings paths
    libcosmicAppWrapperArgs+=(--suffix XDG_DATA_DIRS : "@fallbackXdgDirs@")
}

preFixupPhases+=" libcosmicAppWrapperArgsHook"

wrapLibcosmicApp() {
    local program="$1"
    shift 1
    wrapProgram "$program" "${libcosmicAppWrapperArgs[@]}" "$@"
}

# Note: $libcosmicAppWrapperArgs still gets defined even if ${dontWrapLibcosmicApp-} is set
libcosmicAppWrapHook() {
    # guard against running multiple times for the same prefix (e.g. due to propagation)
    for _ranFor in "${libcosmicAppWrapHookRanFor[@]}"; do
        if [[ "$_ranFor" == "$prefix" ]]; then
            echo "[libcosmicAppWrapHook] already ran for prefix='${prefix}', returning early"
            return 0
        fi
    done
    libcosmicAppWrapHookRanFor+=("$prefix")

    echo "[libcosmicAppWrapHook] prefix='${prefix}'"
    echo "[libcosmicAppWrapHook] dontWrapLibcosmicApp='${dontWrapLibcosmicApp:-}'"
    echo "[libcosmicAppWrapHook] libcosmicAppWrapperArgs=(${libcosmicAppWrapperArgs[*]})"

    if [[ -z "${dontWrapLibcosmicApp:-}" ]]; then
        targetDirsThatExist=()
        targetDirsRealPath=()

        # wrap binaries
        targetDirs=("${prefix}/bin" "${prefix}/libexec")
        echo "[libcosmicAppWrapHook] checking targetDirs: ${targetDirs[*]}"
        for targetDir in "${targetDirs[@]}"; do
            echo "[libcosmicAppWrapHook] checking targetDir='${targetDir}' exists=$([ -d "${targetDir}" ] && echo yes || echo no)"
            if [[ -d "${targetDir}" ]]; then
                targetDirsThatExist+=("${targetDir}")
                targetDirsRealPath+=("$(realpath "${targetDir}")/")
                echo "[libcosmicAppWrapHook] finding executables in '${targetDir}'"
                find "${targetDir}" -type f -executable -print0 |
                    while IFS= read -r -d '' file; do
                        echo "[libcosmicAppWrapHook] wrapping program '${file}'"
                        wrapLibcosmicApp "${file}"
                    done
            fi
        done

        echo "[libcosmicAppWrapHook] targetDirsThatExist=(${targetDirsThatExist[*]})"
        echo "[libcosmicAppWrapHook] targetDirsRealPath=(${targetDirsRealPath[*]})"

        # wrap links to binaries that point outside targetDirs
        # Note: links to binaries within targetDirs do not need
        #       to be wrapped as the binaries have already been wrapped
        if [[ ${#targetDirsThatExist[@]} -ne 0 ]]; then
            echo "[libcosmicAppWrapHook] finding symlinks in targetDirs"
            find "${targetDirsThatExist[@]}" -type l -xtype f -executable -print0 |
                while IFS= read -r -d '' linkPath; do
                    linkPathReal=$(realpath "${linkPath}")
                    echo "[libcosmicAppWrapHook] checking link '${linkPath}' -> '${linkPathReal}'"
                    for targetPath in "${targetDirsRealPath[@]}"; do
                        if [[ "$linkPathReal" == "$targetPath"* ]]; then
                            echo "[libcosmicAppWrapHook] not wrapping link: '$linkPath' (already wrapped)"
                            continue 2
                        fi
                    done
                    echo "[libcosmicAppWrapHook] wrapping link: '$linkPath'"
                    wrapLibcosmicApp "${linkPath}"
                done
        else
            echo "[libcosmicAppWrapHook] no targetDirs exist, skipping symlink wrapping"
        fi
    else
        echo "[libcosmicAppWrapHook] dontWrapLibcosmicApp is set, skipping all wrapping"
    fi
}

fixupOutputHooks+=(libcosmicAppWrapHook)
